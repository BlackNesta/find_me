class MembershipSettingsController < BaseController
  def update
    user = @brand.users.find(params[:id])
    @brand_user = @brand.brand_users.find_by!(user: user)
    @setting = @brand_user.setting || @brand_user.build_setting
    @updated = @setting.update(setting_params)

    render :update, status: @updated ? :ok : :unprocessable_content
  end

  private

  def setting_params
    params.require(:setting).permit(:key, :value)
  end
end
