module ApplicationHelper
  def number(value)
    number_with_precision(value, precision: 0, delimiter: ',')
  end  
end
