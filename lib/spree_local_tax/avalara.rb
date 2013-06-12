module SpreeLocalTax::Avalara
  extend self

  def generate(order)
    builder = InvoiceBuilder.new
    builder.customer = order.email if order.email.present?
    address = order.bill_address
    builder.add_destination(address.firstname, address.lastname, address.address1, address.address2, address.city, address.state.try(:abbr) || address.state_name, address.country.iso, address.zipcode)
    order.line_items.each do |line|
      variant = line.variant
      builder.add_line(variant.sku, variant.product.name, line.quantity, line.total)
    end
    builder.invoice
  end
end
