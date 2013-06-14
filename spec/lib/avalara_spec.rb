require 'spec_helper'

describe SpreeLocalTax::Avalara do
  context "#generate" do
    let(:builder) { mock(:builder) }

    context "guest" do
      let(:address) { stub(:address, firstname: 'Wayne', lastname: 'Gretzky', address1: '123 Main St', address2: '#101', city: 'Toronto', state: stub(:state, abbr: 'ON'), country: stub(:country, iso: 'CA'), zipcode: 'H1H1H1')}
      let(:order)   { stub(:order, email: nil, bill_address: address, line_items: []) }

      before do
        SpreeLocalTax::Avalara::InvoiceBuilder.should_receive(:new).and_return(builder)
        builder.should_receive(:invoice).and_return(:invoice)
        builder.should_not_receive(:customer=)
        builder.should_receive(:add_destination)
        builder.should_receive(:add_origin)
      end

      subject { SpreeLocalTax::Avalara.generate(order, 'clothing') }

      specify { should == :invoice }
    end

    context "user" do
      let(:address) { stub(:address, firstname: 'Wayne', lastname: 'Gretzky', address1: '123 Main St', address2: '#101', city: 'Toronto', state: stub(:state, abbr: 'ON'), country: stub(:country, iso: 'CA'), zipcode: 'H1H1H1')}
      let(:product) { stub(:product, name: 'foo', tax_category: 'clothing')}
      let(:variant) { stub(:variant, sku: '1234', product: product)}
      let(:line1)   { stub(:line, variant: variant, quantity: 2, total: 9.98) }
      let(:line2)   { stub(:line, variant: variant, quantity: 3, total: 14.97) }
      let(:order)   { stub(:order, email: 'wayne@gretzky.com', line_items: [line1, line2]) }

      before do
        SpreeLocalTax::Avalara::InvoiceBuilder.should_receive(:new).and_return(builder)
        SpreeLocalTax::Config.set(origin_address1: '123 Warehouse Dr', origin_address2: '#1010', origin_city: 'Chicago', origin_state: 'IL', origin_country: 'US', origin_zipcode: '12345')

        builder.should_receive(:invoice).and_return(:invoice)
        builder.should_receive(:customer=).with('wayne@gretzky.com')
        builder.should_receive(:add_line).with('1234', 'foo', 2, 9.98)
        builder.should_receive(:add_line).with('1234', 'foo', 3, 14.97)
        builder.should_receive(:add_origin).with('123 Warehouse Dr', '#1010', "Chicago", "IL", "US", "12345")
      end

      subject { SpreeLocalTax::Avalara.generate(order, 'clothing') }

      context "use shipping address" do
        before do
          Spree::Config.tax_using_ship_address = true
          order.stub(ship_address: address)
          builder.should_receive(:add_destination).with('123 Main St', '#101', "Toronto", "ON", "CA", "H1H1H1")
        end

        specify { should == :invoice }

        context "ignores non taxable items" do
          let(:non_taxable_product) { stub(:product, name: 'milk', tax_category: 'food')}
          let(:non_taxable_variant) { stub(:variant, sku: 'NOTAX-1234', product: non_taxable_product)}
          let(:non_taxable_line)    { stub(:line, variant: non_taxable_variant, quantity: 2, total: 9.98) }

          before do
            order.line_items << non_taxable_line
            builder.should_not_receive(:add_line).with('NOTAX-1234', 'milk', 2, 9.98)
          end

          specify { should == :invoice }
        end
      end

      context "use billing address" do
        before do
          Spree::Config.tax_using_ship_address = false
          order.stub(bill_address: address)
          builder.should_receive(:add_destination).with('123 Main St', '#101', "Toronto", "ON", "CA", "H1H1H1")
        end

        specify { should == :invoice }
      end
    end
  end

  context "#compute" do
    let(:invoice) { stub(:invoice) }
    let(:line)     { stub(:line, tax: '4.99') }
    let(:response) { stub(:response, tax_lines: [line, line])}

    before do
      SpreeLocalTax::Config.set avalara_username: 'acme', avalara_password: 'secret', avalara_endpoint: 'http://domain.tld'

      ::Avalara.should_receive(:username=).with('acme')
      ::Avalara.should_receive(:password=).with('secret')
      ::Avalara.should_receive(:endpoint=).with('http://domain.tld')
      ::Avalara.should_receive(:get_tax).with(invoice).and_return(response)
    end

    subject { SpreeLocalTax::Avalara.compute(invoice) }

    specify { should == 9.98 }
  end
end
