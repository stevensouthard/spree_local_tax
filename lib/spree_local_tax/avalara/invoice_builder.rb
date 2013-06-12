module SpreeLocalTax::Avalara
  class InvoiceBuilder
    attr_reader :invoice

    def initialize
      @invoice = Avalara::Request::Invoice.new
    end

    def customer=(value)
      @invoice.customer_code = value
    end
  end
end
