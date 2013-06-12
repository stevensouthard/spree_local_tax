module SpreeLocalTax::Avalara
  extend self

  def generate(order)
    builder = InvoiceBuilder.new
    builder.customer = order.email if order.email.present?
    order.line_items.each do |line|
      variant = line.variant
      builder.add_line(variant.sku, variant.product.name, line.quantity, line.total)
    end
    builder.invoice
  end
end
