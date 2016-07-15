Rails.application.routes.draw do
  resources :survivors, except: [:index, :destroy] do
    post :report_infection, on: :member
  end

  post :trade, to: 'trades#trade'
end
