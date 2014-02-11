class QueueCartController < ApplicationController
	before_action :signed_in_user
	
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
		@user_id = current_user.id
		respond_to do |wants|
			wants.html {  }
			wants.js { render 'queue_cart/show.js.haml' }
		end
	end

	def view_report
		@reports = Execution.where(user_id: current_user.id).group("name").order(created_at: :desc)
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

	def exec_sel
		@user_id = current_user.id
		@exec_id = params[:exec_id]
		@exec_id.each do |ex|
			@execution = QueueCart.find(ex)
			if @execution.test_step_id
				ExecProgress.create(queue_id: @execution.id,user_id: @user_id, test_step_id: @execution.test_step_id, status: 'Start') 
				TestStepWorker.perform_async(@execution.test_step_id,@user_id)
			else
				ExecProgress.create(queue_id: @execution.id,user_id: @user_id, test_id: @execution.test_id, status: 'Start') 
				TestWorker.perform_async(@execution.test_id, @user_id)
			end
		end
		respond_to do |wants|
				wants.html {  }
				wants.js { }
			end	
	end

	def exec_all
		# To do
	end

	def destroy
		@queue = QueueCart.find(params[:id]).delete
		flash.now[:success] = "Job removed from queue!"
		respond_to do |wants|
			wants.js { }
		end
	end

	private
		def signed_in_user
			redirect_to root_url, notice:"Please Sign In" unless signed_in?
		end
		def post_params
			params.require(:queue_cart).permit(:test_suite_id,:test_step_id,:test_id)
		end
end
