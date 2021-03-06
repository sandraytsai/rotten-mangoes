class Admin::UsersController < ApplicationController
  before_action :check_login, :check_admin, :set_admin_user, only: [:show, :edit, :update, :destroy]

  # GET /admin/users
  # GET /admin/users.json
  def index
    @admin_users = User.all.page(params[:page]).per(10)
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
    @admin_user = User.find(params[:id])
  end

  # GET /admin/users/new
  def new
    @admin_user = User.new
  end

  # GET /admin/users/1/edit
  def edit
    @admin_user = User.find(params[:id])
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    @admin_user = User.new(admin_user_params)
    respond_to do |format|
      if @admin_user.save
        format.html { redirect_to [:admin, @admin_user], notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @admin_user }
      else
        format.html { render :new }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    if @admin_user.update(admin_user_params)
      redirect_to [:admin, @admin_user], notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    @admin_user.destroy
    respond_to do |format|
      UserMailer.account_deleted_email(@admin_user).deliver_now
      format.html { redirect_to admin_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def impersonate
    session[:admin_id] = current_user.id
    session[:user_id] = params[:id]
    redirect_to '/'
  end

  def unimpersonate
    session[:user_id] = session[:admin_id]
    session.delete(:admin_id)
    redirect_to '/'
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_user
      @admin_user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_user_params
      params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
    end
end
