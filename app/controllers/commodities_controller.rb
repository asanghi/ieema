class CommoditiesController < ApplicationController
  def index
    @commodities = Commodity.all(:include => :commodity_prices)
    @for_year = (params[:year] || Date.today.year).to_i
    @prev_year = @for_year - 1
    @next_year = @for_year + 1
  end
  
  def show
    @commodity = Commodity.find(params[:id], :include => :commodity_prices)
  end
  
  def new
    @commodity = Commodity.new
  end
  
  def create
    @commodity = Commodity.new(params[:commodity])
    if @commodity.save
      flash[:notice] = "Successfully created commodity."
      redirect_to @commodity
    else
      render :action => 'new'
    end
  end
  
  def edit
    @commodity = Commodity.find(params[:id])
  end
  
  def update
    @commodity = Commodity.find(params[:id])
    if @commodity.update_attributes(params[:commodity])
      flash[:notice] = "Successfully updated commodity."
      redirect_to @commodity
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @commodity = Commodity.find(params[:id])
    @commodity.destroy
    flash[:notice] = "Successfully destroyed commodity."
    redirect_to commodities_url
  end
end
