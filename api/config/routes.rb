require Rails.root.join("app/middleware/metrics_authentication")

Rails.application.routes.draw do
  mount MetricsAuthentication.new(Yabeda::Prometheus::Exporter), at: "/metrics"

  authenticate :user, ->(u) { u.admin? } do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  namespace :api do
    post "logs", to: "logs#create"
    post 'users/create_from_facebook', to: 'users#create_from_facebook'
    get "user_events/:event_id/friend_attendees", to: "user_events#friend_attendees"
    resources :events
    resources :venues, only: [:index, :show]
    resources :artists, only: [:index, :show]
    resources :genres, only: [:index]
    resources :event_attendees, only: [:create, :destroy]
    resources :user_events, only: [:create, :destroy, :index]
    resources :ticket_posts, only: [:index, :create]
    resources :friendships, only: [:index, :create] do
        get :pending, on: :collection
        post :accept, on: :collection
      end
    resource :user, only: [:show] do
      post :upload_avatar
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
end
