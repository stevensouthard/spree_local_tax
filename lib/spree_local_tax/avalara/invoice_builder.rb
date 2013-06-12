module SpreeLocalTax::Avalara
  class InvoiceBuilder
    def initialize
      @invoice = ::Avalara::Request::Invoice.new
      @lines   = []
    end

    def customer=(value)
      @invoice.customer_code = value
    end

    def add_destination(line1, line2, city, region, country, postal_code)
      @destination = address('DESTINATION', line1, line2, city, region, country, postal_code)
    end

    def add_origin(line1, line2, city, region, country, postal_code)
      @origin = address('ORIGIN', line1, line2, city, region, country, postal_code)
    end

    def add_line(item_code, description, quantity, amount)
      @lines << ::Avalara::Request::Line.new(line_no: @lines.count+1,
                                             destination_code: 'DESTINATION',
                                             origin_code:      'ORIGIN',
                                             item_code:        item_code,
                                             description:      description,
                                             qty:              quantity,
                                             amount:           amount)
    end

    def invoice
      @invoice.addresses = [@destination, @origin]
      @invoice.lines     = @lines
      @invoice
    end

  private

    def address(code, line1, line2, city, region, country, postal_code)
      ::Avalara::Request::Address.new(address_code: code, line_1: line1, line_2: line2, city: city, region: region, country: country, postal_code: postal_code)
    end
  end
end
