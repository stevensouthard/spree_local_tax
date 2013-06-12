module SpreeLocalTax::Avalara
  extend self

  def generate(order)
    generator = InvoiceGenerator.new
    generator.customer = order.email if order.email.present?
    generator.invoice
  end
end
