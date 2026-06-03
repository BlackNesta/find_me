class UsersController < BaseController
  def create
    @brand_user = AddUserToBrand.result(
      brand: @brand,
      user_id: params[:existing_user_id].presence,
      user_params: user_params,
      setting_params: setting_params
    ).brand_user

    @brand.reload
    @created = @brand_user.persisted?
    @available_users = available_users

    render :create, status: @created ? :ok : :unprocessable_content
  end

  def destroy
    user = @brand.users.find(params[:id])
    @removed = @brand.brand_users.find_by!(user: user)
    @removed.destroy
    @brand.reload
    @available_users = available_users

    render :destroy
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:first_name, :last_name, :email)
  end

  def setting_params
    params.fetch(:setting, {}).permit(:key, :value)
  end
end
