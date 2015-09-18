FlyoverComments::Engine.routes.draw do
  resources :comments, only: [:index, :create, :destroy, :update, :show] do
    resources :flags, only: :create
  end
end
