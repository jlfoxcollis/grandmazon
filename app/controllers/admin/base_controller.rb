class Admin::BaseController < ApplicationController
  before_action :authenticate_user!, except: [:create]
   before_action do
     redirect_to new_user_session_path unless current_user && current_user.admin?
   end

   # private
   #
   # def admin_only
   #   render file: "/public/404" unless current_user.admin?
   # end

end
