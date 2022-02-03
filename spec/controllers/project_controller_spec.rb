require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to be_successful
      end

      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    let(:user) { FactoryBot.create(:user)}
    let(:project) { FactoryBot.create(:project, owner: user)}
    context "as an authorized user" do
      it "responds successfully" do
        sign_in user
        get :show, params: { id: project.id }
        expect(response).to be_successful
      end
    end

    context "as an unauthorized user" do
      let(:user1) { FactoryBot.create(:user)}
      it "redirects to the dash board" do
        sign_in user1
        get :show, params: { id: project.id }
        expect(response).to_not be_successful
      end
    end
  end
end
