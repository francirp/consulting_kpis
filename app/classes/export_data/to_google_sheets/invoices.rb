class ExportData::ToGoogleSheets::Invoices < ExportData::ToGoogleSheets
  HEADERS = [
    'Issue Date',
    'Last Payment Date',
    'ID',
    'PO Number',
    'Client',
    'Subject',
    'Invoice Amount',
    'Paid Amount',
    'Balance',
    'Subtotal',
    'Discount',
    'Tax',
    'Tax2',
    'Currency',
    'Currency Symbol',
    'Document Type',
    'Client Address',
  ]

  private

  def range
    'Invoices!A1'
  end

  # rubocop:disable Metrics/MethodLength
  def array_of_arrays
    invoices = pull_invoices
    invoices.map do |invoice|
      [
        Date.parse(invoice.issued_at).strftime('%m/%d/%Y'),
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
        ''
      ]
    end
  end
  # rubocop:enable Metrics/MethodLength

  def headers
    HEADERS
  end

  def spreadsheet_id
    KPIS_SPREADSHEET
  end

  def pull_invoices
    harvest = Harvest::Wrapper.new.harvest
    page = 1
    invoices = []
    more_pages_left = true
    while more_pages_left
      response = harvest.invoices.all(page: page, updated_since: Time.now.utc.to_date.beginning_of_year)
      invoices << response
      more_pages_left = response.count == 50 ? true : false
      page += 1
    end
    invoices.flatten
  end
end
