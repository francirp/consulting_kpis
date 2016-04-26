module Harvest::Calculations

  def self.roundup(float)
    return float if float.ceil == float.floor
    decimal = float - float.floor
    new_decimal = 0.0
    if decimal <= 0.25
      new_decimal = 0.25
    elsif decimal <= 0.5
      new_decimal = 0.5
    elsif decimal <= 0.75
      new_decimal = 0.75
    else
      new_decimal = 1.00
    end
    return float.floor + new_decimal
  end

  def roundup(float)
    self.roundup(floats)
  end

end
