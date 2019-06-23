require 'faker'

FactoryGirl.define do

  factory :user do
    email "superadmin@example.com"
    password "123456"
    password_confirmation "123456"
    name "Superadmin"
    confirmed_at Date.today
    approved 'T'
    role_id "1"
  end

end