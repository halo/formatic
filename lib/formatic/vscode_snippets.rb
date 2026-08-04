# frozen_string_literal: true

require 'tmpdir'

module Formatic
  # Installs the gem's VS Code snippets as a symlink inside the host
  # application's `.vscode` directory.
  #
  # This runs in every process that boots the host application (Spring
  # preloader, Puma workers, rake tasks, ...), so those processes race each
  # other. A non-atomic remove-then-create (`FileUtils.ln_s(force: true)`)
  # lets two processes both pass the "does it exist?" check before either
  # creates the link, so one of them dies with `Errno::EEXIST` on
  # `symlink(2)`.
  #
  # To stay race-free the link is created under a temporary name in the
  # system temp directory and then `rename(2)`-ed over the target, which
  # atomically replaces whatever is already there.
  #
  # NOTE: `Formatic::File` (a ViewComponent) shadows `File` inside this
  # module, so we refer to Ruby's file class as `::File`.
  module VscodeSnippets
    class << self
      def install(target, source)
        target = target.to_s
        source = source.to_s

        return if already_linked?(target, source)

        install_atomically(target, source)
      end

      private

      def install_atomically(target, source)
        tmp = ::File.join(Dir.tmpdir, "formatic-#{Process.pid}-#{Thread.current.object_id}.tmp")
        FileUtils.rm_f(tmp)
        ::File.symlink(source, tmp)
        ::File.rename(tmp, target)
      rescue Errno::EXDEV
        replace(target, source)
      ensure
        FileUtils.rm_f(tmp) if tmp
      end

      def already_linked?(target, source)
        ::File.symlink?(target) && ::File.readlink(target) == source
      end

      def replace(target, source)
        FileUtils.rm_f(target)
        ::File.symlink(source, target)
      end
    end
  end
end
