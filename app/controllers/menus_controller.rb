class MenusController < ApplicationController
	before_action :signed_in_user, except: :welcome
	def home
		@user_id = current_user.id
		respond_to do |wants|
			wants.html {  render 'home.html.haml' }
		end
		
	end
	private
		def signed_in_user
	      redirect_to root_url, notice:"Please Sign In" unless signed_in?
	    end
end
