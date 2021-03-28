require 'rails_helper'

RSpec.describe Consumer, type: :model do
  
  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:total_consumed) }

  describe 'POST /create' do 

  end
end
