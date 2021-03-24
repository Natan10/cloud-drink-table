require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "create account" do
    context "valid params" do
      let(:create_account) { create(:account)}

      it 'valid count' do
        expect{
          create_account
        }.to change{Account.count}.from(0).to(1) 
      end
    end

    context "invalid params" do
      it "invalid user" do
        account = build(:account,user: nil)
        expect{account.save!}.to raise_error(ActiveRecord::RecordInvalid)  
      end
    end    
  end
end
