require "rails_helper"

RSpec.describe Consumer, type: :model do
  let(:account) {create(:account)}
  
  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:total_consumed) }
  
  describe "create consumer" do
    context "valid params" do
      it 'valid params' do
        consumer = build(:consumer,account: account)
        expect(consumer.save!).to be_truthy  
      end
    end
    
    context "invalid params" do
      it 'without name' do
        consumer = build(:consumer,name: nil,account: account)
        expect{consumer.save!}.to raise_error{ActiveRecord::RecordInvalid}
      end

      it 'without account' do
        consumer = build(:consumer,account: nil)
        expect{consumer.save!}.to raise_error{ActiveRecord::RecordInvalid}
      end
    end
  end

  describe "update consumer" do
    let(:consumer) {create(:consumer,account: account)}
    context "valid params" do
      it 'name and total_consumed' do
        params = {
          name: 'Natan',
          total_consumed: 152.0
        }
        
        expect(consumer.update(params)).to be_truthy
      end
    end

    context "invalid params" do 
      it 'name nil' do 
        params = {
          name: nil
        }
        expect(consumer.update(params)).to be_falsey
      end

      it 'total_consumed negative' do 
        params = {
          total_consumed: -1
        }
        expect(consumer.update(params)).to be_falsey
      end
    end
  end

  describe "destroy consumer" do 
    let(:consumer) {create(:consumer,account: account)}
    it { expect(consumer.destroy).to be_truthy }
  end
end
