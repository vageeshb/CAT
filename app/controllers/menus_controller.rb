class MenusController < ApplicationController
	before_action :signed_in_user, except: :welcome
	def home
		@user_id = current_user.id
		render 'home.html.haml'
	end
	private
		def signed_in_user
	      redirect_to root_url, notice:"Please Sign In" unless signed_in?
	    end
end
