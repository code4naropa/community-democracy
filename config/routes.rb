Rails.application.routes.draw do

  # External
  post 'subscribe_to_newsletter' => 'newsletter_subcriptions#create', as: :create_subscription

  # Sessions
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  # FriendshipRequests
  get 'friend-requests' => 'friendship_requests#index', as: :friendship_requests_received
  post 'friendship-request/:username' => 'friendship_requests#create', as: :add_friend
  delete 'friendship-request/:username' => 'friendship_requests#destroy', as: :reject_friendship_request

  # Friendships
  post 'friendship/:username' => 'friendships#create', as: :accept_friendship_request
  delete 'friendship/:username' => 'friendships#destroy', as: :end_friendship

  # Posts
  resources :posts, only: [:new, :create, :show, :destroy], :path => "post" do
    resources :comments, only: [:create, :destroy], :path => "comment"
  end

  # Private Conversations & Messages
  resources :private_conversations, only: [:new, :show, :destroy], :path => "conversation"
  resources :private_messages, only: [:create], :path => "message"
  get '/conversations' => "private_conversations#index", as: :private_conversations_home

  # Like Path
  post '/:likable_type/:likable_id/like', to: 'likes#create', as: :like
  delete '/:likable_type/likable_id/like', to: 'likes#destroy', as: :unlike

  # Profiles -- this must be last
  get '/:username', to: 'profiles#show', as: :profile

  # we need to route people based on whether or not they are logged in
  #root 'sessions#new'

  root 'static#home'

end
