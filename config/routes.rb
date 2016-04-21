FlyoverComments::Engine.routes.draw do
  resources :comments, only: [:index, :create, :destroy, :update, :show] do
    resources :flags, only: :create
    resources :votes, only: [:create, :update, :destroy]
    resources :replies, only: :index
  end
end
