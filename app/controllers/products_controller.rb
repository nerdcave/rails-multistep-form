class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :edit, :destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    wizard = ModelWizard.new(Product, session).start
    @product = wizard.object
  end

  def edit
    ModelWizard.new(Product, session).start(@product)
  end

  def create
    wizard = ModelWizard.new(Product, session, params).process(:product)
    @product = wizard.object
    if wizard.save
      redirect_to @product, notice: "Product saved!"
    else
      render :new
    end
  end

  def update
    wizard = ModelWizard.new(Product, session, params).process(:product, @product)
    if wizard.save
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url
  end

private

  def set_product
    @product = Product.find(params[:id])
  end

end
