module SpreeLocalTax::Avalara
  class InvoiceBuilder
    def initialize
      @invoice = ::Avalara::Request::Invoice.new
    end

    def customer=(value)
      @invoice.customer_code = value
    end

    def add_destination(line1, line2, city, region, country, postal_code)
      @destination = ::Avalara::Request::Address.new(address_code: 'DESTINATION', line_1: line1, line_2: line2, city: city, region: region, country: country, postal_code: postal_code)
    end

    def add_origin(line1, line2, city, region, country, postal_code)
      @origin = ::Avalara::Request::Address.new(address_code: 'ORIGIN', line_1: line1, line_2: line2, city: city, region: region, country: country, postal_code: postal_code)
    end

    def invoice
      @invoice.addresses = [@destination, @origin]
      @invoice
    end
  end
end
