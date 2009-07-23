class CommoditiesController < ApplicationController
  def index
    @commodities = Commodity.all(:include => :commodity_prices)
    @for_year = (params[:year] || Date.today.year).to_i
    @prev_year = @for_year - 1
    @next_year = @for_year + 1
  end

  def graph
    @commodity = Commodity.find(params[:id], :include => :commodity_prices)
    title = Title.new("Commodity Price for #{@commodity.name}")
    lines = []
    color = "6363AC"
    max = 0
    line = LineHollow.new
    line.text = @commodity.code
    line.colour = "##{color}"
    line.width = 1
    line.dot_size = 5
    line.tooltip = '#val# on #x_label#'
    prices = @commodity.commodity_prices.map{|cp|cp.try(:price)||0}
    labels = @commodity.commodity_prices.map{|cp|cp.try(:price_date).try(:to_s,:short_month_and_year)}
    line.values = prices
    lines << line
    max = prices.max

    y = YAxis.new
    step = (max/10).ceil
    y.set_range(0,max+(step*2),step)

    x_legend = XLegend.new(@commodity.name)
    x_legend.set_style('{font-size: 20px; color: #778877}')
    
    y_legend = YLegend.new("Commodity Index")
    y_legend.set_style('{font-size: 20px; color: #770077}')

    x_labels = XAxisLabels.new
    x_labels.set_vertical()

    x_labels.labels = labels.map{|l| XAxisLabel.new(l, '#000000', 10, -70)}

    x = XAxis.new
    x.set_labels(x_labels)

    chart =OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
    chart.x_axis = x
    chart.add_element(line)
    
    render :text => chart.to_s
  end
  
  def show
    @commodity = Commodity.find(params[:id], :include => :commodity_prices)
    @graph = open_flash_chart_object(900,300,graph_commodity_path(@commodity))
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
