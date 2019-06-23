require 'rails_helper'
require 'support/controller_macros'
RSpec.describe  GroupsController, :type => :controller do 


before :each do
  role = FactoryGirl.create(:role,id:2,name: "Superadmin")
  @user = FactoryGirl.create(:user,id: 2, email: 'todelete@gmaail.com',role_id:2)
  allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
  allow(controller).to receive(:current_user).and_return(@user)
end
  describe 'GET #new' do
    it "requires login" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
    it{ expect(response).to be_success    }
  end


  describe "GET #index" do
    login_user
    it "responds successfully with an HTTP 302 status code" do
      get :index
      expect(response).to have_http_status(302)
    end
    it "renders the index template" do
      get :index
      expect(response).to redirect_to root_path
    end
    it "matches the index of groups" do
      expect(:get => '/groups').to route_to(:controller => "groups", :action => "index")
    end

    context "with invalid attributes" do
      it "does not save the new group" do
        expect{
          post :create, group: FactoryGirl.attributes_for(:invalid_group)
        }.to_not change(Group, :count)
      end
      it "re-renders the new method" do
        post :create, group: FactoryGirl.attributes_for(:invalid_group)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET #show" do
    login_user
    it "assigns the requested group to @group" do
      group = FactoryGirl.create(:group)
      get :show, id: group
    end
    it "renders the #show view" do
      get :show, id: FactoryGirl.create(:group)
      expect(response).to redirect_to root_path
    end
  end

  describe 'DELETE destroy' do
    login_user
    context "success" do
      it "deletes the group" do
        group = FactoryGirl.create(:group,name: "delete",id: 1)
        expect(response).to have_http_status(200)
        expect { delete :destroy, :id => group.id }.to change(Group, :count).by(-1)
        expect(flash[:notice]).to eq 'Group was successfully destroyed.'
      end
    end
  end

  context 'Group #create' do
    let!(:group) { FactoryGirl.create :group }
    login_user
    it 'create a new group' do
      expect { post:create, :id => group.id }.to change(Group, :count).by(1)
      params = FactoryGirl.create(:group, id:2, name: 'abc@example.com')
      expect(User.count).to eq(1)
      expect(:notice).to be_present
    end
  end



end

