Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # مسارات التوثيق
      post 'signup', to: 'users#create'
      post 'login', to: 'sessions#create'

      # مسارات البوستات والتعليقات
      resources :posts do
        resources :comments, only: [:create, :update, :destroy]
      end
    end
  end
end
