class SessionsController < ApplicationController
	def new
		
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
		  	sign_in user
		  	redirect_to home_path

		else
			respond_to do |wants|
				wants.html {  }
				wants.js { render 'sessions/fail.js.haml'}
			end
      		
		end
	end

	def destroy
		sign_out
    	redirect_to root_url
	end
end
