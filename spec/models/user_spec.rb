require 'rails_helper'

RSpec.describe User, type: :model do
  #有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # 姓、名、メール、パスワードがあれば有効な状態であること
  it "is valid with a first name, last name, email, and password" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "is invalid without a first name" do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "aaron@example.com")
    user = FactoryBot.build(:user, email: "aaron@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  # フルネームを返すインスタンスメソッドが仕事しているか
  it "returns a user's full name as a string" do
    user = User.new(
      first_name:  "Joe",
      last_name:  "Tester",
      email:      "tester@example.com",
    )
    expect(user.name).to eq ("Joe Tester")
  end
end
