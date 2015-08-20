FlyoverComments::Engine.routes.draw do
  resources :comments, only: [:create, :destroy, :update, :show] do
    resources :flags, only: :create
  end
end
