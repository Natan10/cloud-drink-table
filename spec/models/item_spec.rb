require 'rails_helper'

RSpec.describe Item, type: :model do
  
  let(:account) {create(:account)}
  let(:consumer) {create(:consumer,account: account)}

  it { should validate_numericality_of(:price_cents) }
  it { should validate_numericality_of(:quantity) }
  it { should validate_presence_of(:name) }

  it 'total price' do 
    item = create(:item,quantity: 3,price_cents: 100,consumer: consumer) 
    expect(item.total_price).to eq(300.0)
  end

  describe 'create item' do 
    context 'valid params ' do 
      it 'valid consumer' do 
        item = build(:item,consumer: consumer)
        expect(item.save!).to be_truthy
      end
    end

    context "invalid params" do
      it 'whitout name' do 
        item = build(:item,name: nil,consumer: consumer)
        expect(item.save).to be_falsey  
        expect { item.save! }.to raise_error { ActiveRecord::RecordInvalid }
      end

      it 'whitout consumer' do 
        item = build(:item,consumer: nil)
        expect(item.save).to be_falsey  
        expect { item.save! }.to raise_error { ActiveRecord::RecordInvalid }
      end

      it 'quantity negative' do 
        item = build(:item,quantity: -1,consumer: consumer)
        expect(item.save).to be_falsey  
        expect { item.save! }.to raise_error { ActiveRecord::RecordInvalid }
      end
    end
  end
  
  describe 'update item' do 
    let(:create_item) { create(:item,consumer: consumer) }

    context 'valid params' do 
      it 'save' do
        item = create_item
        params = {
          name: "molho de cenoura",
          quantity: 3,
          price_cents: 52.0
        }
        expect(item.update(params)).to be_truthy
      end
    end
    context 'invalid params' do 
      it 'name nil' do 
        item = create_item
        params = {
          name: nil,
          quantity: 3,
          price_cents: 52.0
        }
        expect(item.update(params)).to be_falsey
      end

      it 'quantity nil' do 
        item = create_item
        params = {
          name: 'carneess',
          quantity: nil,
          price_cents: 52.0
        }
        expect(item.update(params)).to be_falsey
      end

      it 'price nil' do 
        item = create_item
        params = {
          name: 'carneess',
          quantity: 5,
          price_cents: nil
        }
        expect(item.update(params)).to be_falsey
      end
    end
  end

  describe "destroy item" do
    let(:create_item) { create(:item,consumer: consumer) }
    it { expect(create_item.destroy).to be_truthy }
  end
  
end
