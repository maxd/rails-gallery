RailsGallery::Application.routes.draw do

  root to: 'gallery#index'

  get '/gallery/albums' => 'gallery#albums'

  resources :albums do
    get 'confirm_destroy', on: :member
  end

end
