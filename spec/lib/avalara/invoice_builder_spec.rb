require 'spec_helper'

describe SpreeLocalTax::Avalara::InvoiceBuilder do
  let(:builder) { SpreeLocalTax::Avalara::InvoiceBuilder.new }

  context "#add_destination" do
    before do
      builder.customer = 'user@example.com'
      builder.add_destination('123 Main St.', '#101', 'Toronto', 'ON', 'CA', 'H1H1H1')
      builder.add_origin('123 W Main St.', '#1000', 'Chicago', 'IL', 'US', '12345')
      builder.add_line('X-1234', 'Hockey Gloves', 2, 99.98)
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

    context "destination" do
      subject { builder.invoice.Addresses[1] }

      its(:AddressCode) { should == 'ORIGIN' }
      its(:Line1)       { should == '123 W Main St.' }
      its(:Line2)       { should == '#1000' }
      its(:City)        { should == 'Chicago' }
      its(:Region)      { should == 'IL' }
      its(:Country)     { should == 'US' }
      its(:PostalCode)  { should == '12345' }
    end

    context "line" do
      subject { builder.invoice.Lines[0] }

      its(:LineNo) { should == 1 }
      its(:ItemCode) { should == 'X-1234'}
      its(:DestinationCode) { should == 'DESTINATION'}
      its(:OriginCode) { should == 'ORIGIN'}
      its(:Description) { should == 'Hockey Gloves'}
      its(:Qty) { should == 2 }
      its(:Amount) { should == 99.98 }
    end
  end
end
