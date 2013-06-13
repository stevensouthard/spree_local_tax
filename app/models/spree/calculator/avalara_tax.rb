require 'avalara'

module Spree
  class Calculator::AvalaraTax < Calculator::LocalTax
    def self.description
      I18n.t(:avalara_tax)
    end

    def compute(order)
      invoice = avalara.generate(order)
      amount  = avalara.compute(invoice)

      round_to_two_places(amount)
    rescue
      compute_order(order)
    end

  private
    def avalara
      SpreeLocalTax::Avalara
    end
  end
end
