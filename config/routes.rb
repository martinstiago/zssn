Rails.application.routes.draw do
  resources :survivors, except: [:index, :destroy] do
    post :report_infection, on: :member
  end

  post :trade, to: 'trades#trade'

  namespace :reports do
    get :infected, to: 'reports#infected'
    get 'non-infected', to: 'reports#non_infected'
    get :resources, to: 'reports#resources'
    get :points, to: 'reports#points'
  end
end
