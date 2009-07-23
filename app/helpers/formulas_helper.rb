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
    "<br/>#{f.buffer} + <br/>#{descriptions}"
  end

  def add_fc_link(name, form)
    link_to_function name do |page|
      task = render(:partial => 'formula_component', :locals => { :pf => form, :formula_component => FormulaComponent.new })
      page << %{
var new_formula_component_id = "new_" + new Date().getTime();
$('formula_components').insert({ bottom: "#{ escape_javascript task }".replace(/new_\\d+/g, new_formula_component_id) });
}
    end
  end

end
