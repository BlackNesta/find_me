module SessionsHelper
  extend ActiveSupport::Concern

  included do
    before_action :load_brand
  end

  protected

  def load_brand
    @brand = Brand.first

    raise StandardError.new("Probably you forgot do something :)") if @brand.nil?
  end
end
