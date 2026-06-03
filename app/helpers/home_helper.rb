module HomeHelper
  def brand_nav_link_class(brand, selected_brand)
    classes = ["list-group-item", "list-group-item-action"]
    classes << "active" if brand == selected_brand
    classes.join(" ")
  end
end
