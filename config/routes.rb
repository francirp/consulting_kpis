Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  root to: 'pages#dashboard', as: "dashboard"
  resources :projects
  resources :team_members
  resources :clients, only: [:index]

  post '/update-report' => 'pages#update_report', as: :update_report

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
