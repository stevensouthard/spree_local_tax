require 'spec_helper'

describe Spree::Calculator::AvalaraTax do
  let(:order) { mock(:order) }
  let(:invoice) { mock(:invoice) }
  let(:calculator) { Spree::Calculator::AvalaraTax.new }

  before do
    SpreeLocalTax::Avalara.should_receive(:generate).with(order).and_return(invoice)
  end

  context "#compute" do
    context "without errors" do
      before do
        SpreeLocalTax::Avalara.should_receive(:compute).with(invoice).and_return(9.984)
      end

      specify { calculator.compute(order).should == 9.98 }
    end
    context "with errors" do
      before do
        calculator.stub(compute_order: 1.05)
        SpreeLocalTax::Avalara.should_receive(:compute).with(invoice).and_raise('invalid address')
      end

      specify { calculator.compute(order).should == 1.05 }
    end
  end
end
