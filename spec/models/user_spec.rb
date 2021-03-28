require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_uniqueness_of(:email) }
  it { should have_secure_password }

  describe "created user" do
    context "valid user" do
      it "valid params" do
        user = build(:user)
        expect {
          user.save
        }.to change { User.count }.from(0).to(1)
      end
    end

    context "invalid params" do
      it "invalid email" do
        user_one = build(:user, email: nil)
        user_second = build(:user, email: "natan.com")
        expect(user_one.save).to eq(false)
        expect(user_second.save).to eq(false)
      end

      it "email duplicated" do
        email = Faker::Internet.email
        user_one = create(:user, email: email)
        user_second = build(:user, email: email)
        expect(user_second.save).to eq(false)
      end

      it "invalid password" do
        user = build(:user, password: nil)
        expect(user.save).to eq(false)
      end
    end
  end
end
