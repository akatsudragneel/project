require 'rails_helper'
require 'support/controller_macros'
RSpec.describe  WelcomeController, :type => :controller do 

  describe "GET #index" do
  	login_user
  	it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  	
  	it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
    it "not render contact us layout"do
      expect(:get => 'contact'). 
      not_to render_with_layout 
    end
    it "not render about us layout" do
      expect(:get => 'about'). 
      not_to render_with_layout 
    end
  end
end  