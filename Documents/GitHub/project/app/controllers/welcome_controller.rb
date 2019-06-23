class WelcomeController < ApplicationController # Controller for welcome page which remains open until user signs in
  def index
  # Displays welcome page contents i.e. Caraousel  	
  end

  def contact #Modal for Contact page
    render :layout => false
  end

  def about  #Modal for About page
    render :layout => false
  end	
end
