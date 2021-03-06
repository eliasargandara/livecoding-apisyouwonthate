class ProductsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error :not_found, :product_not_found
  end

  def index
    products = Product.take(10)
    render json: products
  end

  def show
    product = Product.find(params[:id])
    render json: product
  end

  def create
    product = Product.new(create_params)

    if !product.save
      render_json_validation_error product
      return
    end

    render json: product.reload, status: :created
  end

  def update
    product = Product.find(params[:id])

    if !product.update(update_params)
      render status: :bad_request
      return
    end

    render json: product, status: :ok
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy!
    render nothing: true, status: :no_content
  end

  private

  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: allowed_fields + [:manufacturer])
  end

  def update_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: allowed_fields)
  end

  def allowed_fields
    [:name, :description, :product_type, :apv]
  end
end
