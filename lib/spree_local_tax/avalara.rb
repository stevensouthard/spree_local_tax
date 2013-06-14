module SpreeLocalTax::Avalara
  extend self

  def generate(order, tax_category)
    address = Spree::Config.tax_using_ship_address ? order.ship_address : order.bill_address
    builder = InvoiceBuilder.new

    builder.customer = order.email if order.email.present?

    builder.add_destination(address.address1, address.address2, address.city, address.state.try(:abbr) || address.state_name, address.country.iso, address.zipcode)
    builder.add_origin(config.origin_address1, config.origin_address2, config.origin_city, config.origin_state, config.origin_country, config.origin_zipcode)

    order.line_items.each do |line|
      variant = line.variant
      product = variant.product
      builder.add_line(variant.sku, product.name, line.quantity, line.total) if product.tax_category == tax_category
    end

    builder.invoice
  end

  def compute(invoice)
    ::Avalara.username = SpreeLocalTax::Config.avalara_username
    ::Avalara.password = SpreeLocalTax::Config.avalara_password
    ::Avalara.endpoint = SpreeLocalTax::Config.avalara_endpoint

    response = ::Avalara.get_tax(invoice)

    response.tax_lines.inject(0) {|sum, line| sum + line.tax.to_f }
  end

private
  def config
    SpreeLocalTax::Config
  end
end
