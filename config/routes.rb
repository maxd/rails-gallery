RailsGallery::Application.routes.draw do

  root to: 'gallery#index'

  resources :albums do
    resources :items, only: :index

    get 'confirm_destroy', on: :member
  end

  resources :items, only: :index

  get 'uploader' => 'upload#uploader'
  post 'upload' => 'upload#upload'

end
