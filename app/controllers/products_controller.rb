class ProductsController < ApplicationController
  before_action :load_product, only: [:show, :update, :edit, :destroy]
  before_action :load_wizard, only: [:new, :edit, :create, :update]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = @wizard.object
  end

  def edit
  end

  def create
    @product = @wizard.object
    if @wizard.save
      redirect_to @product, notice: "Product saved!"
    else
      render :new
    end
  end

  def update
    if @wizard.save
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

  def load_product
    @product = Product.find(params[:id])
  end

  def load_wizard
    @wizard = ModelWizard.new(@product || Product, session, params)
    if self.action_name.in? %w[new edit]
      @wizard.start
    elsif self.action_name.in? %w[create update]
      @wizard.process
    end
  end

end
