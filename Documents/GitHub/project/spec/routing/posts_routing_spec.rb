RSpec.describe PostsController, type: :routing do
 describe 'routing' do
    let!(:group) { FactoryGirl.create(:group) }
    let!(:post) { FactoryGirl.create(:post) }
     
    it 'routes to #index' do
      expect(get: '/groups/1/posts').to route_to('posts#index',:group_id => "1")
    end

    it 'routes to #show' do
     expect(get: '/groups/1/posts/1').to route_to('posts#show',:group_id => "1", :id => '1')
    end

    it 'routes to #new' do
     expect(get: '/groups/1/posts/new').to route_to('posts#new',:group_id => "1")
    end

    it 'routes to #vote' do
     expect(put: like_group_post_path(group.id, 1)).to route_to('posts#vote',:group_id => "1", :id => '1')
    end
   	
   	it 'routes to #update via PUT' do
	   expect(put: '/groups/1/posts/1').to route_to('posts#update',:group_id => "1", id: '1')
	  end
	  
	  it 'routes to #update via PATCH' do
	   expect(patch: '/groups/1/posts/1').to route_to('posts#update',:group_id => "1", id: '1')
	  end
  end
end
