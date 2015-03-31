class UsersController < ApplicationController
  before_filter :set_user
  layout 'session'

  def new
  end

  def create
  end

  def edit
    redirect_to root_path if current_user.nil?
    @user = current_user
  end

  def update
    if @user.update_attributes(user_params)
      unless @user.admin?
      redirect_to edit_user_path, notice: t('flash.users.updated')
    else
       redirect_to dashboard_municipio_contacts_path(current_user.municipio), notice: t('flash.users.updated')
    end
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :business_name,
      :address,
      :operation_license,
      :operation_license_file,
      :land_permission_file
    )
  end

  def set_user
    @user ||= current_user
  end
end
