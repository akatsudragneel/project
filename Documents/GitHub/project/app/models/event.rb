#Model for handling storage of events fetched from google calendar when registration is done using Google account 
class Event < ActiveRecord::Base
  belongs_to :user
end
