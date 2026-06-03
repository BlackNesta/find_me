class BrandSettingsController < BaseController
  def create
    @setting = @brand.settings.new(setting_params)
    @created = @setting.save

    render :create, status: @created ? :ok : :unprocessable_content
  end

  def destroy
    @setting = @brand.settings.find(params[:id])
    @setting.destroy

    render :destroy
  end

  private

  def setting_params
    params.require(:setting).permit(:key, :value)
  end
end
