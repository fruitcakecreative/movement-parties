require Rails.root.join("app/middleware/metrics_authentication")

Rails.application.routes.draw do
  mount MetricsAuthentication.new(Yabeda::Prometheus::Exporter), at: "/metrics"

  # Typical operator flow: sign in with Devise (e.g. POST /api/login with credentials, same-site session
  # cookie), then open /admin on the React dev origin (e.g. http://localhost:3002/admin for movement — CRA
  # proxies to this app), or http://localhost:3001/admin when hitting Rails only. The React app’s /profile
  # and related API routes are optional.
  if Rails.env.development?
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  else
    authenticate :user, ->(u) { u.admin? } do
      mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    end
  end

  namespace :api do
    post "logs", to: "logs#create"
    post 'users/create_from_facebook', to: 'users#create_from_facebook'
    get "user_events/:event_id/friend_attendees", to: "user_events#friend_attendees"
    get "user_events/:event_id/friend_rsvps", to: "user_events#friend_rsvps"
    get "user_events/:event_id/friend_counts", to: "user_events#friend_counts"
    post "user_events/friend_counts_batch", to: "user_events#friend_counts_batch"
    delete "user_events", to: "user_events#destroy_by_params"
    get "users/:user_id/user_events", to: "user_events#for_user", constraints: { user_id: /\d+/ }
    get "users/:user_id/friends", to: "friendships#friends_of_user", constraints: { user_id: /\d+/ }
    get "users/:id", to: "users#show_by_id", constraints: { id: /\d+/ }
    resources :events do
      member do
        get :rsvp_totals
      end
    end
    resources :venues, only: [:index, :show]
    resources :artists, only: [:index, :show]
    resources :genres, only: [:index]
    resources :event_attendees, only: [:create, :destroy]
    resources :user_events, only: [:create, :index]
    resources :ticket_posts, only: [:index, :create]
    resources :friendships, only: [:index, :create] do
      get :pending, on: :collection
      get :search, on: :collection
      post :accept, on: :collection
      post :reject, on: :collection
    end
    delete "friendships", to: "friendships#destroy"
    resource :user, only: [:show, :update] do
      post :upload_avatar
      get :schedule_share_avatar
    end
  end

  devise_for :users,
  path: 'api',
  path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'users'
  },
  controllers: {
    sessions: 'api/users/sessions',
    registrations: 'api/users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    post 'api/login', to: 'api/users/sessions#create'
    delete 'api/logout', to: 'api/users/sessions#destroy'
  end

  get "up" => "rails/health#show", as: :rails_health_check
  # Browsers hitting https://api…/ get a 200 instead of a misleading 404 (this host is the API, not a site).
  root to: "rails/health#show"
end
