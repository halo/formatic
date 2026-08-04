# frozen_string_literal: true

require 'tmpdir'

# The engine installs the gem's VS Code snippet file as a symlink inside the
# host application's `.vscode` directory. This runs in every process that
# boots the host application (Spring preloader, Puma workers, rake tasks, ...),
# so concurrent boots race each other. A non-atomic remove-then-create raises
# `Errno::EEXIST` when two processes both reach `symlink(2)` for the same path.
class VscodeSnippetsTest < ApplicationTest
  def setup
    @sandbox = Dir.mktmpdir
    @source = File.join(@sandbox, 'vscode', 'formatic.code-snippets')
    @target = File.join(@sandbox, '.vscode', 'formatic.code-snippets')
    FileUtils.mkdir_p(File.dirname(@source))
    FileUtils.mkdir_p(File.dirname(@target))
    FileUtils.touch(@source)
  end

  def teardown
    FileUtils.remove_entry(@sandbox)
  end

  def test_install_creates_a_symlink_to_the_source
    Formatic::VscodeSnippets.install(@target, @source)

    assert File.symlink?(@target)
    assert_equal @source, File.readlink(@target)
  end

  def test_install_is_idempotent
    Formatic::VscodeSnippets.install(@target, @source)
    Formatic::VscodeSnippets.install(@target, @source)

    assert File.symlink?(@target)
    assert_equal @source, File.readlink(@target)
  end

  def test_install_replaces_an_existing_regular_file
    FileUtils.touch(@target)

    Formatic::VscodeSnippets.install(@target, @source)

    assert File.symlink?(@target)
    assert_equal @source, File.readlink(@target)
  end

  def test_install_replaces_a_stale_symlink
    File.symlink(File.join(@sandbox, 'elsewhere'), @target)

    Formatic::VscodeSnippets.install(@target, @source)

    assert File.symlink?(@target)
    assert_equal @source, File.readlink(@target)
  end

  def test_install_leaves_no_temp_files_behind
    Formatic::VscodeSnippets.install(@target, @source)

    leftovers = Dir.children(File.dirname(@target)) - ['formatic.code-snippets']

    assert_empty leftovers
  end

  def test_install_never_raises_when_apps_boot_concurrently
    raised = drain(run_concurrent_installs)

    assert_empty raised, "concurrent installs raised: #{raised.first.inspect}"
    assert File.symlink?(@target)
    assert_equal @source, File.readlink(@target)
  end

  private

  def run_concurrent_installs(rounds: 40, threads: 8)
    errors = Queue.new
    rounds.times do
      FileUtils.rm_f(@target) # simulate a fresh boot every round
      threads.times.map do
        Thread.new { install_rescuing(errors) }
      end.each(&:join)
    end
    errors
  end

  def install_rescuing(errors)
    Formatic::VscodeSnippets.install(@target, @source)
  rescue StandardError => e
    errors << e
  end

  def drain(errors)
    raised = []
    raised << errors.pop until errors.empty?
    raised
  end
end
