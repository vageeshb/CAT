class ObjectRepositoriesController < ApplicationController
  before_action :set_object_repository, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user
  # GET /object_repositories
  # GET /object_repositories.json
  def index
    @object_repositories = ObjectRepository.where(:user_id => current_user.id).to_a
    @object_repository = ObjectRepository.new
  end

  # GET /object_repositories/1
  # GET /object_repositories/1.json
  def show
  end

  # GET /object_repositories/new
  def new
    @object_repository = ObjectRepository.new
    respond_to do |format|
      format.js { render 'create.js.haml' }
    end
  end

  def show

    respond_to do |wants|
      wants.html {  }
      wants.js {}
    end
  end
  
  def edit
    respond_to do |format|
      format.js { }
    end
  end

  def create
    @object_repository = ObjectRepository.new(object_repository_params)
      if @object_repository.save
        @object_repositories = ObjectRepository.where(:user_id => current_user.id).to_a
        respond_to do |format|
          flash.now[:success] = 'Object repository was successfully created.'
          format.html { redirect_to @object_repository, notice: 'Object repository was successfully created.' }
          format.js { render 'index.js.haml'}
        end
      else
        respond_to do |format|
          format.html { render action: 'new' }
          format.js { render 'create.js.haml' }
        end
    end
  end

  # PATCH/PUT /object_repositories/1
  # PATCH/PUT /object_repositories/1.json
  def update
    respond_to do |format|
      if @object_repository.update(object_repository_params)
        @object_repositories=ObjectRepository.where(:user_id => current_user.id).to_a
        flash.now[:success] = 'Object repository was successfully updated.'
        format.html { redirect_to @object_repository, notice: 'Object repository was successfully updated.' }
        format.js { render 'index.js.haml'}
      else
        format.html { render action: 'edit' }
        format.js { render 'fail_create.js.haml' }
      end
    end
  end

  # DELETE /object_repositories/1
  # DELETE /object_repositories/1.json
  def destroy
    
    @object_repository.destroy
    @object_repositories = ObjectRepository.where(:user_id => current_user.id).to_a
    respond_to do |format|
      flash.now[:success] = "Object repository \'#{@object_repository.name}\' was successfully deleted."
      format.html { }
      format.js { render 'index.js.haml' }
    end
  end
  private
    def signed_in_user
      redirect_to root_url, notice:"Please Sign In" unless signed_in?
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_object_repository
      @object_repository = ObjectRepository.find(params[:id])
      @web_elements = @object_repository.web_elements
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def object_repository_params
      params.require(:object_repository).permit(:name, :description, :url, :attachments, :user_id)
    end
    
end
