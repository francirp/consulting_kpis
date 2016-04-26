class ProjectDecorator < Draper::Decorator
  delegate_all

  def revenue
    h.number_to_currency(object.revenue.round, precision: 0)
  end

  def costs
    h.number_to_currency(object.costs.round, precision: 0)
  end

  def profit
    h.number_to_currency(object.profit.round, precision: 0)
  end

  def profit_margin
    h.number_to_percentage(object.profit_margin * 100, precision: 1)
  end

end
