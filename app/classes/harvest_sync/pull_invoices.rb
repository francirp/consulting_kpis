module HarvestSync
  class PullInvoices
    attr_reader :start_date, :end_date, :harvest_wrapper

    def initialize(args = {})
      @start_date = args.fetch(:start_date, Date.today - 2.months)
      @end_date = args.fetch(:end_date, Date.today.end_of_year)
      @harvest_wrapper = HarvestedWrapper.new
    end

    def call
      clients = Client.all.group_by(&:harvest_id)
  
      keep_fetching = true
      page = 1
      while keep_fetching
        puts page
        response = HarvestApi::GetInvoices.new(start_date, end_date, page: page).call
        array = response['invoices'].map do |invoice|
          hash = transform_invoice(invoice)
          hash.merge(
            client_id: clients[invoice.dig('client', 'id')].first.id,
          )
        end
        Invoice.upsert_all(array, unique_by: :harvest_id)
        keep_fetching = response['total_pages'] > page && response['total_pages']
        page += 1
      end
    end

    private

    def transform_invoice(invoice)
      {
        issue_date: invoice["issue_date"],
        harvest_id: invoice["id"],
        amount: invoice["amount"],
        paid_date: invoice["paid_date"],
        sent_at: invoice["sent_at"],
        period_start: invoice["period_start"],
        period_end: invoice["period_end"],
        state: invoice["state"],
        payment_term: invoice["payment_term"],
        created_at: invoice["created_at"],
        updated_at: invoice["updated_at"],
        is_retainer: invoice.dig('retainer', 'id').present?,
      }
    end    
  end
end