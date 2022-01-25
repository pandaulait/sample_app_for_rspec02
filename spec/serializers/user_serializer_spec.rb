require 'rails_helper'

RSpec.describe "UserSerializer", type: :serializer do
  context "when create user" do
    let(:user) { FactoryBot.create(:user) }
    it "matches to serialized JSON" do
      serializer = UserSerializer.new(user)
      expect(serializer.to_json).to eq(user.to_json(:only => [:id, :first_name, :email]))
    end
  end
end