require 'avalara'

module Spree
  class Calculator::AvalaraTax < Calculator::LocalTax
    def self.description
      I18n.t(:avalara_tax)
    end

    def compute(order)
      invoice = avalara.generate(order)

      avalara.compute(invoice)
    end

  private
    def avalara
      SpreeLocalTax::Avalara
    end
  end
end
