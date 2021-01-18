class ApplicationController < ActionController::Base
  helper_method :cart

  def cart
    cart ||= Cart.new(session[:cart])
  end
end
