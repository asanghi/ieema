class FormulasController < ApplicationController

  def import
    file_param = params[:excel_file]
    Spreadsheet.client_encoding = 'UTF-8'
    begin
      spreadsheet = Spreadsheet.open(file_param.local_path)
      (commodity_count,formula_count,prices_count) = Formula.import!(spreadsheet)
      flash[:notice] = "#{formula_count} formulas imported with #{commodity_count} commodities and #{prices_count} prices"
      redirect_to root_path
    rescue Exception => e
      flash[:error] = "Error uploading Excel file : #{e.to_s}"
      redirect_to new_import_formulas_path
    end
  end

  def index
    if params[:id] && !params[:billing_date].blank? && !params[:tender_date].blank?
      @formula = Formula.find(params[:id])
      if @formula
        begin
          @formula.billing_date = params[:billing_date]
          @formula.tender_date = params[:tender_date]
          @result = @formula.calculate
        rescue Exception => e
          flash[:error] = e.to_s
        end
      end
    end
  end
  
  def show
    @formula = Formula.find(params[:id])
  end
  
  def new
    @formula = Formula.new
    DEFAULT_BLANK_COMPONENTS.times {@formula.formula_components.build }
  end
  
  def create
    @formula = Formula.new(params[:formula])
    if @formula.save
      flash[:notice] = "Successfully created formula."
      redirect_to @formula
    else
      render :action => 'new'
    end
  end
  
  def edit
    @formula = Formula.find(params[:id])
  end
  
  def update
    @formula = Formula.find(params[:id])
    if @formula.update_attributes(params[:formula])
      flash[:notice] = "Successfully updated formula."
      redirect_to @formula
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @formula = Formula.find(params[:id])
    @formula.destroy
    flash[:notice] = "Successfully destroyed formula."
    redirect_to formulas_url
  end
end
