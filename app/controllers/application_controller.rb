class ApplicationController < ActionController::Base
  helper_method :cart
  before_action :set_locale

  def cart
    cart ||= Cart.new(session[:cart])
  end

  private
  def set_locale
    I18n.locale = params[:lang] || locale_from_header || I18n.default_locale
  end

  # Grabbing weighted value of language from user browser
  def locale_from_header
    request.env.fetch('HTTP_ACCEPT_LANGUAGE', '').scan(/[a-z]{2}/).first
  end

  def default_url_options(options = {})
    {lang: I18n.locale}
  end
end
