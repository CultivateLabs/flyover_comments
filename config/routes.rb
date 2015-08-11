FlyoverComments::Engine.routes.draw do
  resources :comments, only: [:create, :destroy, :update] do
    resources :flags, only: :create
  end
end
