require 'faker'

FactoryGirl.define do

  factory :group do
    name "abcdef"
    desc  "this is body for abcdef"
  end

  factory :invalid_group, parent: :group do |f|
    f.name nil
  end

end  