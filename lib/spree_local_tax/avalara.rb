module SpreeLocalTax::Avalara
  extend self

  def generate(order)
    address = Spree::Config.tax_using_ship_address ? order.ship_address : order.bill_address
    builder = InvoiceBuilder.new

    builder.customer = order.email if order.email.present?

    builder.add_destination(address.firstname, address.lastname, address.address1, address.address2, address.city, address.state.try(:abbr) || address.state_name, address.country.iso, address.zipcode)

    order.line_items.each do |line|
      variant = line.variant
      builder.add_line(variant.sku, variant.product.name, line.quantity, line.total)
    end

    builder.invoice
  end

  def compute(invoice)
    ::Avalara.username = SpreeLocalTax::Config.avalara_username
    ::Avalara.password = SpreeLocalTax::Config.avalara_password
    ::Avalara.endpoint = SpreeLocalTax::Config.avalara_endpoint
    ::Avalara.get_tax(invoice)
  end
end
