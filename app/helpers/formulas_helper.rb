module FormulasHelper

  def component_description(fc)
    "#{fc.weight}*#{fc.commodity.code}/#{fc.commodity.code}<sub>0</sub>"
  end

  def formula_description(f)
    f.formula_components.map{|fc| component_description(fc)}.join(" + ")
  end

  def result_descriptive(f)
    descriptions = f.formula_components.map do |fc|
      fc.billing_date = f.billing_date
      fc.tender_date = f.tender_date
      fc.descriptive_weight
    end.join(" + <br/>")
    "<br/>(#{f.buffer} + <br/>#{descriptions})"
  end

end
