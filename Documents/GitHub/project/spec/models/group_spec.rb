require 'rails_helper'

RSpec.describe Group,type: :model do

  context 'validations' do    
    before { FactoryGirl.build(:user)}

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:desc) }
    it "is invalid without a name" do
      group = FactoryGirl.build(:group, name: nil)
      group.valid?
      expect(group.errors[:name]).to include("can't be blank")
    end
    it "is invalid without a description" do
      group = FactoryGirl.build(:group, desc: nil)
      group.valid?
      expect(group.errors[:desc]).to include("can't be blank")
    end
  end

  context 'association' do
    it { should have_many(:posts) }
  
    it { should have_many(:users) }
  end

  it { should accept_nested_attributes_for(:memberships) }

  it { should have_db_column(:is_public).of_type(:boolean) }

  it { should have_db_index(:is_public) }

end
