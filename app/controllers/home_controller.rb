class HomeController < BaseController
  def index
    @brands = Brand.order(:id)
    @brand_users = @brand.brand_users.includes(:user, :setting).order(:created_at)
    @brand_settings = @brand.settings.order(:key)
    @available_users = available_users
  end
end
