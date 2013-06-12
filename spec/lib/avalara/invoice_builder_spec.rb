require 'spec_helper'

describe SpreeLocalTax::Avalara::InvoiceBuilder do
  let(:builder) { SpreeLocalTax::Avalara::InvoiceBuilder.new }

  subject { builder.invoice }

  context "#customer=" do
    before { builder.customer = :name }

    its(:CustomerCode) { should == :name }
  end

  context "#add_destination"
  context "#add_origin"
  context "#add_line"
end
