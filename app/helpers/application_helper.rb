module ApplicationHelper
  def number(value)
    number_with_precision(value, precision: 0, delimiter: ',')
  end

  def pulse_rating_color_class(rating)
    return "" unless rating.present?
    return "green" if rating >= 2.5
    return "orange" if rating >= 2
    return "red"
  end
end
