Rails.application.routes.draw do
  resources :posts
  devise_for :users
  mount FlyoverComments::Engine => "/flyover_comments"
  root to: "posts#index"
end
