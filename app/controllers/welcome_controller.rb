class WelcomeController < ApplicationController
  before_action :set_items
  before_action :cart

  def index
  end

  def show
  end

  private

  def set_items
    @merchants = User.where(merchant: true)
  end
end
