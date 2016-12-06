Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    resources :items
    root to: "items#index"
  end


  # API subdomain perposes
  # Below code is as example in case if you want to use something within
  # subdomain like api.example.com. Forr this cases create controllers in
  # app/controllers/api/v1/controller_name

  # constraints subdomain: 'api', defaults: { format: :json } do
  #   scope module: 'api' do
  #     namespace :v1 do
  #       resources :items #, only: [:index, :show, :create, :update]
  #     end
  #   end
  # end
end
