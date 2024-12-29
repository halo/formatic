# Overriding Lookbook
class PreviewController < ViewComponentsController
  around_action :switch_locale

  def switch_locale(&)
    locale = params[:lookbook][:display][:lang] || I18n.default_locale
    I18n.with_locale(locale, &)
  end
end
