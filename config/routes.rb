Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#dashboard', as: "dashboard"
  resources :projects

  namespace :api do
    namespace :v1 do
      resources :time_entries do
        collection do
          get :team_billable
        end
      end
    end
  end
end
