module ProductsHelper
  def build_product(product)
    product.categories.build if product.categories.empty?
    product
  end
end
