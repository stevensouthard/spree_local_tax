require 'spec_helper'

describe SpreeLocalTax::Avalara do
  context "generate" do
    let(:generator) { mock(:generator) }

    context "guest" do
      let(:order) { mock(:order, email: nil) }

      before do
        SpreeLocalTax::Avalara::InvoiceGenerator.should_receive(:new).and_return(generator)
        generator.should_receive(:invoice).and_return(:invoice)
        generator.should_not_receive(:customer=)
      end

      subject { SpreeLocalTax::Avalara.generate(order) }

      specify { should == :invoice }
    end

    context "user" do
      let(:order) { mock(:order, email: 'wayne@gretzky.com') }

      before do
        SpreeLocalTax::Avalara::InvoiceGenerator.should_receive(:new).and_return(generator)
        generator.should_receive(:invoice).and_return(:invoice)
        generator.should_receive(:customer=).with('wayne@gretzky.com')
      end

      subject { SpreeLocalTax::Avalara.generate(order) }

      specify { should == :invoice }
    end
  end

  context "calculate"
end
