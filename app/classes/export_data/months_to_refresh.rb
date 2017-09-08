class ExportData::MonthsToRefresh
  attr_reader :date, :num_prior_months

  def initialize(args = {})
    @date = args.fetch(:date, Date.today)
    @num_prior_months = args.fetch(:num_prior_months, 2)
  end

  def months_to_refresh
    months = []
    prior_date = date - num_prior_months
    new_date = prior_date.dup
    while new_date < date
      months << new_date.strftime('%m')[0..2].upcase
      new_date = new_date + 1.month
    end

    prior_date

    month_one = Date.today.strftime('%m')[0..2]
    month_two = (Date.today - 1.month).strftime('%m')[0..2]
    worksheets = [
      worksheets_by_month[month_one],
      worksheets_by_month[month_two],
    ]

    date.year == date_x_months_ago
    date_x_months_ago
  end


  def worksheets
    date_x_months_ago = date - num_prior_months.months
    date_x_months_ago.month

  end
end