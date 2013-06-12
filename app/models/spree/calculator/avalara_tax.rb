require 'avalara'

module Spree
  class Calculator::AvalaraTax < Calculator::LocalTax
    def self.description
      I18n.t(:avalara_tax)
    end

    def find_local_tax(order)
      tax_address = Spree::Config[:tax_using_ship_address] ? order.ship_address :  order.bill_address

      Avalara.username = 'bryan@godynamo.com'
      Avalara.password = 'dynamo'
      Avalara.endpoint = 'https://development.avalara.net'

      invoice     = Avalara::Request::Invoice.new(customer_code: order.email || 'guest' )
      origin      = Avalara::Request::Address.new(address_code: 1, line1: '1600 Amphitheatre Pkwy', city: 'Mountain View', region: 'CA', country: 'USA', postal_code: '94043')
      destination = Avalara::Request::Address.new(address_code: 2, line1: '1 Infinite Loop', city: 'Cupertino', region: 'CA', country: 'USA', postal_code: '95014')
      line        = Avalara::Request::Line.new(line_no: 1, destination_code: 2, origin_code: 1, item_code: 'X123', description: 'T-Shirt', qty: 1, amount: 9.99)
    end

    def compute(order)
      SpreeLocalTax::Avalara.compute(order)
    end
  end

end
