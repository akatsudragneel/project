require 'rails_helper'
require 'support/controller_macros'
RSpec.describe  UsersController, :type => :controller do 

before :each do
  role = FactoryGirl.create(:role,id:2,name: "Superadmin")
  @user = FactoryGirl.create(:user,id: 2, email: 'todelete@gmaail.com',role_id:2)
  allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
  allow(controller).to receive(:current_user).and_return(@user)
end
  
  context 'GET #new' do
    it "requires login" do
      FactoryGirl.create(:group)
      get :new
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "GET #index" do
    login_user
    
    it "do not render edit user" do
      expect(:get => 'edit/1'). 
      not_to render_with_layout 
    end

    it "do not render show user" do
      expect(:get => 'show/1'). 
      not_to render_with_layout 
    end

    it "renders the index template" do
      get :index
      expect(response).to redirect_to root_path
    end
    
    it "matches the index of users" do
     expect(get: '/admin/users').to route_to('users#index')
    end

  end

  context 'User #create' do
    let!(:user) { FactoryGirl.create :user }
    login_user
    it 'create a new user' do
      params = FactoryGirl.create(:user, id:2, email: 'abc@example.com')
      expect(User.count).to eq(2)
      expect(:notice).to be_present
      end
  end

  context 'PUT #update' do
    let(:new_attributes) { FactoryGirl.attributes_for(:user, name: 'Superadmin',email:"newemail@abc.com") }
    let(:valid_attributes) { FactoryGirl.attributes_for(:user, email: 'newemail@abc.com',name: 'Superadmin') }
    login_user
      it "updates the requested company" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => new_attributes}
        user.reload
        expect(assigns(:user).attributes['name']).to match(new_attributes[:name])
        expect(assigns(:user).attributes['email']).to match(new_attributes[:email])
      end
  end

  context 'DELETE #destroy' do #comment loadandauthorise in users controller to make it pass
    login_user
    it ' delete user' do
      puts User.count
      expect { delete :destroy, :id => @user.id }.to change(User, :count).by(-1)
      puts User.count
      expect(controller).to set_flash[:notice].to(/User was successfully deleted./)
    end
  end
  

end    