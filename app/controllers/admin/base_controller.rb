class Admin::BaseController < ApplicationController
  before_action :authenticate_user!, except: [:create]
   before_action do
     unless current_user && current_user.admin?
       redirect_to root_path, notice:  "ACCESS DENIED"
     end
   end

end
