module SpreeLocalTax::Avalara
  extend self

  def generate(order)
    generator = InvoiceGenerator.new
    generator.customer = order.email if order.email.present?
    order.line_items.each do |line|
      variant = line.variant
      generator.add_line(variant.sku, variant.product.name, line.quantity, line.total)
    end
    generator.invoice
  end
end
