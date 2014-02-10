class QueueCartController < ApplicationController
	def add_ts
		@queue = QueueCart.new(post_params)
		
		respond_to do |wants|
			if @queue.save
				flash[:notice] = 'Queue was successfully created.'
				wants.html { redirect_to(@queue) }
				wants.js { render '' }
			else
				wants.js { render '' }
			end
		end
	end

	def show
		@queues = QueueCart.all
		respond_to do |wants|
			wants.html {  }
			wants.js { render 'queue_cart/show.js.haml' }
		end
	end

	def view_report
		@reports = Execution.where(user_id: current_user.id).group("name")
	  	respond_to do |wants|
	  		wants.html { }
	  		wants.js { }
	  	end
	end
	def show_report
		@executions = Execution.where(user_id: current_user.id, name: params[:name])
	  	@steps = Array.new
	  	@final_status = "Pass"
	  	@executions.each do |e|
	  		@steps.push TestStep.find(e.test_step_id)
	  		if e.status == "Fail" then @final_status="Fail" end
	  	end
	end
	private
		def post_params
			params.require(:queue_cart).permit(:test_step_id,:test_id)
		end
end
