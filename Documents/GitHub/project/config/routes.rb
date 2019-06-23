Rails.application.routes.draw do
  post 'notifications/notify' => 'notifications#notify'  
  post 'twilio/voice' => 'twilio#voice'
  root to: "welcome#index"
  
  get 'events/index'
  
  get 'contact', :to => "welcome#contact"
  
  get 'about', :to => "welcome#about"

  devise_for :users, :controllers => { :invitations =>'users/invitations', :omniauth_callbacks => "omniauth_callbacks"} 
    scope "/admin" do  
      resources :users do
        member do
          patch :unapproved
        end  
      end
    end 

  resources :groups do
    
    resources :posts do
      member do
        put "like" => "posts#vote"
      end
      resources :comments,only: [:create, :destroy,:update,:edit] do
        resources :comments
      end
    end
    
    member do
      get 'add_members'
      patch 'remove_member'
    end
  end 

  resources :invitations, only:[:index]
  
  authenticated :user do  
    root :to => 'groups#index', as: :authenticated_root
  end

end
