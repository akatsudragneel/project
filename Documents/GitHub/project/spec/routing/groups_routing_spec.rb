RSpec.describe GroupsController, type: :routing do
 describe 'routing' do
 		let!(:group) { FactoryGirl.create(:group, id: 1) }

	  it 'routes to #index' do
	    expect(get: '/groups').to route_to('groups#index')
	  end

	  it 'routes to #show' do
	   expect(get: '/groups/1').to route_to('groups#show', id: '1')
	  end

	  it 'routes to #new' do
	   expect(get: '/groups/new').to route_to('groups#new')
	  end
	 
	  it 'routes to #add_members' do
	   expect(get: '/groups/1/add_members').to route_to('groups#add_members', id: '1')
	  end
	  
	  it 'routes to #remove_member via PATCH' do
	   expect(patch: '/groups/1/remove_member').to route_to('groups#remove_member', id: '1')
	  end
  end
end
