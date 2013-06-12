require 'spec_helper'

describe SpreeLocalTax::Avalara::InvoiceBuilder do
  let(:builder) { SpreeLocalTax::Avalara::InvoiceBuilder.new }

  context "#add_destination" do
    before do
      builder.customer = 'user@example.com'
      builder.add_destination('123 Main St.', '#101', 'Toronto', 'ON', 'CA', 'H1H1H1')
    end

    subject { builder.invoice }

    its(:CustomerCode) { should == 'user@example.com' }

    context "destination" do
      subject { builder.invoice.Addresses[0] }

      its(:AddressCode) { should == 'DESTINATION' }
      its(:Line1)       { should == '123 Main St.' }
      its(:Line2)       { should == '#101' }
      its(:City)        { should == 'Toronto' }
      its(:Region)      { should == 'ON' }
      its(:Country)     { should == 'CA' }
      its(:PostalCode)  { should == 'H1H1H1' }
    end
  end
end
