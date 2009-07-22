class CommodityPricesController < ApplicationController
  def index
    @commodity_prices = CommodityPrice.all(:order => 'price_date desc')
    @commodities = Commodity.all(:order => 'code')
    @prices = ActiveSupport::OrderedHash.new
    @commodity_prices.each do |cp|
      price_year = cp.price_date.year
      price_month = cp.price_date.month
      @prices[price_year] ||= {}
      @prices[price_year][price_month] ||= {}
      @prices[price_year][price_month][cp.commodity] = cp
    end
  end
  
  def show
    @commodity_price = CommodityPrice.find(params[:id])
  end
  
  def new
    @commodity_price = CommodityPrice.new
  end
  
  def create
    @commodity_price = CommodityPrice.new(params[:commodity_price])
    if @commodity_price.save
      flash[:notice] = "Successfully created commodity price."
      redirect_to @commodity_price
    else
      render :action => 'new'
    end
  end
  
  def edit
    @commodity_price = CommodityPrice.find(params[:id])
  end
  
  def update
    @commodity_price = CommodityPrice.find(params[:id])
    if @commodity_price.update_attributes(params[:commodity_price])
      flash[:notice] = "Successfully updated commodity price."
      redirect_to @commodity_price
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @commodity_price = CommodityPrice.find(params[:id])
    @commodity_price.destroy
    flash[:notice] = "Successfully destroyed commodity price."
    redirect_to commodity_prices_url
  end
end
