class UpdateBrand < Actor
  input :brand
  input :attributes

  def call
    brand.update(attributes)
  end
end
