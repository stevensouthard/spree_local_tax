module SpreeLocalTax::Avalara
  extend self

  def generate(order)
    ::Avalara::Request::Invoice.new(customer_code: order.email || 'guest')
  end
end
