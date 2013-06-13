require 'spec_helper'

describe Spree::Calculator::AvalaraTax do
  let(:order) { mock(:order) }
  let(:invoice) { mock(:invoice) }
  let(:calculator) { Spree::Calculator::AvalaraTax.new }

  before do
    SpreeLocalTax::Avalara.should_receive(:generate).with(order).and_return(invoice)
    SpreeLocalTax::Avalara.should_receive(:compute).with(invoice).and_return(9.984)
  end

  context "#compute" do
    specify { calculator.compute(order).should == 9.98 }
  end
end
