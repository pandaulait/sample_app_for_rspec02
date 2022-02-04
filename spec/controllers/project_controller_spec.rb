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
      let(:user1) { FactoryBot.create(:user) }
      it "redirects to the dash board" do
        sign_in user1
        get :show, params: { id: project.id }
        expect(response).to_not be_successful
      end
    end
  end

  describe "#create" do
    let(:user1) { create(:user) }
    context "as an authenticated user" do
      context "with valid attributes" do
        it "adds a project" do
          project_params = FactoryBot.attributes_for(:project)
          sign_in user1
          expect {
            post :create, params: {project: project_params }
          }.to change(user1.projects, :count).by(1)
        end
      end
    end
    context "as an authenticated user" do
      context "with invalid attributes" do
        it "does not adds a project" do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in user1
          expect {
            post :create, params: {project: project_params }
          }.not_to change(user1.projects, :count)
        end
      end
    end
    context "as a guest" do
      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status "302"
      end
      it "redirects to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    context "as an authorized user" do
      let(:user) { create(:user) }
      let(:project) { create(:project, owner: user)}

      it "updates a project" do
        project_params = FactoryBot.attributes_for(:project, name: "Update Project Name")
        sign_in user
        patch :update, params: {id: project.id, project: project_params}
        expect(project.reload.name).to eq "Update Project Name"
      end
    end

    context "as a unauthoeized user" do
      let(:user) { create(:user)}
      let(:user1) { create(:user) }
      let(:project) { create(:project, owner: user1, name: "Same Old Name") }

      it "does not update the project" do
        project_params = FactoryBot.attributes_for(:project, name: "New Name")
        sign_in user
        patch :update, params: { id: project.id, project: project_params }
        expect(project.reload.name).to eq "Same Old Name"
      end

      it "redirect to the dashbord" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in user
        patch :update, params: { id: project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#destroy" do
    let(:user) { create(:user)}
    let(:project) { create(:project, owner: user) }
    context "as an authorized user" do
      it "deletes a project" do
        sign_in user
        project
        expect {
          delete :destroy, params: { id: project.id }
        }.to change(user.projects, :count).by(-1)
      end
    end
  end
end
