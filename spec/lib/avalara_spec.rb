require 'spec_helper'

describe SpreeLocalTax::Avalara do
  context "generate" do
    let(:generator) { mock(:generator) }

    context "guest" do
      let(:order) { mock(:order, email: nil, line_items: []) }

      before do
        SpreeLocalTax::Avalara::InvoiceGenerator.should_receive(:new).and_return(generator)
        generator.should_receive(:invoice).and_return(:invoice)
        generator.should_not_receive(:customer=)
      end

      subject { SpreeLocalTax::Avalara.generate(order) }

      specify { should == :invoice }
    end

    context "user" do
      let(:product) { mock(:product, name: 'foo')}
      let(:variant) { mock(:variant, sku: '1234', product: product)}
      let(:line1)   { mock(:line, variant: variant, quantity: 2, total: 9.98) }
      let(:line2)   { mock(:line, variant: variant, quantity: 3, total: 14.97) }
      let(:order)   { mock(:order, email: 'wayne@gretzky.com', line_items: [line1, line2]) }

      before do
        SpreeLocalTax::Avalara::InvoiceGenerator.should_receive(:new).and_return(generator)
        generator.should_receive(:invoice).and_return(:invoice)
        generator.should_receive(:customer=).with('wayne@gretzky.com')
        generator.should_receive(:add_line).with('1234', 'foo', 2, 9.98)
        generator.should_receive(:add_line).with('1234', 'foo', 3, 14.97)
      end

      subject { SpreeLocalTax::Avalara.generate(order) }

      specify { should == :invoice }
    end
  end

  context "calculate"
end
