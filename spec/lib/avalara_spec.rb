require 'spec_helper'

describe SpreeLocalTax::Avalara do
  context "generate" do
    context "guest" do
      let(:order) { mock(:order, email: nil) }

      subject { SpreeLocalTax::Avalara.generate(order) }

      specify { should be_kind_of(Avalara::Request::Invoice) }
      its(:CustomerCode) { should == 'guest' }
    end

    context "user" do
      let(:order) { mock(:order, email: 'wayne@gretzky.com') }
      subject { SpreeLocalTax::Avalara.generate(order) }

      specify { should be_kind_of(Avalara::Request::Invoice) }
      its(:CustomerCode) { should == 'wayne@gretzky.com' }
    end
  end

  context "calculate"
end
