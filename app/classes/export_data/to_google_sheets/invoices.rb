class ExportData::ToGoogleSheets::Invoices < ExportData::ToGoogleSheets
  HEADERS = [
    'Issue Date',
    'Last Payment Date',
    'ID',
    'PO Number',
    'Client',
    'Subject',
    'Invoice Amount',
    'Due Amount',
    'Balance',
    'Subtotal',
    'Discount',
    'Tax',
    'Tax2',
    'Currency',
    'Currency Symbol',
    'Document Type',
    'Client Address',
    'Year',
    'Month',
    'Retainer?',
  ]

  private

  def range
    'Harvest Invoices!A1'
  end

  # rubocop:disable Metrics/MethodLength
  def array_of_arrays
    invoices = pull_invoices
    invoices.map do |invoice|
      date = Date.parse(invoice.issued_at)
      month = date.mday > 14 ? date.month : date.month - 1
      month = month == 0 ? 12 : month
      year = date.month == 1 && month == 12 ? date.year - 1 : date.year

      [
        date.strftime('%m/%d/%Y'),
        '',
        invoice.id,
        '',
        invoice.client_name,
        invoice.subject,
        invoice.amount,
        invoice.due_amount,
        '',
        invoice.discount_amount,
        invoice.tax_amount,
        invoice.tax2_amount,
        '',
        '',
        '',
        '',
        '',
        year,
        month,
        invoice.retainer_id.present? ? 'Yes' : 'No',
      ]
    end
  end
  # rubocop:enable Metrics/MethodLength

  def headers
    HEADERS + [Time.now.utc.strftime('%m/%d/%Y')]
  end

  def spreadsheet_id
    KPIS_SPREADSHEET
  end

  def pull_invoices
    harvest = Harvest::Wrapper.new.harvest
    page = 1
    invoices = []
    more_pages_left = true
    date = Date.new(Time.now.utc.to_date.year - 1, 1, 1) # pull two years of invoices
    while more_pages_left
      response = harvest.invoices.all(page: page, updated_since: date)
      invoices << response
      more_pages_left = response.count == 50 ? true : false
      page += 1
    end
    invoices.flatten
  end
end
