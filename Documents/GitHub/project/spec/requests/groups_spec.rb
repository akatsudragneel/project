# require 'spec_helper'

# describe "Groups" do
#   describe "Manage groups" do
#     describe "user settings" do
#       before :each do
#       let(:authed_user) { create_logged_in_user }
#     end
#    end 
#     it "visit home page", :js => true do
#       # visit contact_path
#     end  
#     it "check contacts us for the page", :js => true do
#       # visit root_path
#     end  
#     it "displays the user's username after successful login", :type => :request, :js => true do
#        #visit groups_path
#          @user = FactoryGirl.create :user
#           visit '/users/sign_in'
#           fill_in 'user_email', with: @user.email
#           fill_in 'user_password', with: @user.password
#           click_button "Sign in"
#           visit root_path
#           visit '/users/sign_in'
          
#        #    expect(page).to have_content(true)
#        # visit groups_path
#        # fill_in 'user_name', with: @user.name
#        # fill_in 'user_email', with: @user.email
          
#       # fill_in('group_name', :with => 'Johnny Group')
#       # fill_in('desc', :with => 'John blah bakh')
#       # click_button('Create group')
#       # find('Create Group')
#       # page.should have_content("Group was successfully created")
#     end
#   end
# end