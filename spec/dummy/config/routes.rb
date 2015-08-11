Rails.application.routes.draw do
  devise_for :users, class_name: "Ident::User"
  resources :posts
  mount FlyoverComments::Engine => "/flyover_comments"
  root to: "posts#index"
  get 'flags' => 'flags#show'
end
