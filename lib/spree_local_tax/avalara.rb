module SpreeLocalTax::Avalara
  extend self

  def generate(order)
    address = Spree::Config.tax_using_ship_address ? order.ship_address : order.bill_address
    builder = InvoiceBuilder.new

    builder.customer = order.email if order.email.present?

    builder.add_destination(address.firstname, address.lastname, address.address1, address.address2, address.city, address.state.try(:abbr) || address.state_name, address.country.iso, address.zipcode)
    builder.add_origin(tax_config.origin_address1, tax_config.origin_address2, tax_config.origin_city, tax_config.origin_state, tax_config.origin_country, tax_config.origin_zipcode)

    order.line_items.each do |line|
      variant = line.variant
      builder.add_line(variant.sku, variant.product.name, line.quantity, line.total)
    end

    builder.invoice
  end

  def tax_config
    SpreeLocalTax::Config
  end

  def compute(invoice)
    ::Avalara.username = SpreeLocalTax::Config.avalara_username
    ::Avalara.password = SpreeLocalTax::Config.avalara_password
    ::Avalara.endpoint = SpreeLocalTax::Config.avalara_endpoint

    response = ::Avalara.get_tax(invoice)

    response.tax_lines.inject(0) {|sum, line| sum + line.tax.to_f }
  end
end
