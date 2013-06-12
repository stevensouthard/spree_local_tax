require 'spec_helper'

describe Spree::Calculator::AvalaraTax do
  let(:order) { mock(:order) }
  let(:calculator) { Spree::Calculator::AvalaraTax.new }

  before do
    SpreeLocalTax::Avalara.should_receive(:compute).with(order).and_return(:amount)
  end

  context "#compute" do
    specify { calculator.compute(order).should == :amount }
  end
end
