Rails.application.routes.draw do
  resources :survivors, except: [:index, :destroy] do
    post :report_infection, on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
