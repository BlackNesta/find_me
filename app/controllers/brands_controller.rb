class BrandsController < BaseController
  skip_before_action :load_brand, only: :create

  def create
    brand = Brand.new(brand_params)

    if brand.save
      redirect_to root_path(brand_id: brand.id), notice: "Brand created"
    else
      redirect_to root_path, alert: brand.errors.full_messages.to_sentence
    end
  end

  def update
    UpdateBrand.result(brand: @brand, attributes: brand_params)
    render :update, status: @brand.errors.any? ? :unprocessable_content : :ok
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end
end
