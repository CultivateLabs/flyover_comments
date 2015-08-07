FlyoverComments::Engine.routes.draw do
  resources :comments, only: [:create, :destroy] do
    resources :flags, only: :create
  end
end
