Rails.application.routes.draw do
  if Rails.env.development?
    apipie
  end
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :articles do
        member do
          post :add_tag
          post :destroy_tag
          post :recommend
        end
      end
      resources :comments do
        collection do
          get :replies
        end
        member do
          post :recommend
        end
      end
      resources :profiles, except: :destroy do
        collection do
          get :following
          get :autocomplete
        end
        member do
          post :follow
          post :unfollow
          post :transfer
          post :add_tag
          post :destroy_tag
          post :star, action: :add_star
          delete :star, action: :destroy_star
          post :tab, action: :add_to_tab
          delete :tab, action: :remove_from_tab
        end
      end
      resources :profile_comments do
        collection do
          get :replies
        end
        member do
          post :recommend
        end
      end
      namespace :users do
        post :sign_in
        post :sign_up
        get :me
        post :profile_image, action: :upload_profile_image
        delete :profile_image, action: :destroy_profile_image
      end
      namespace :tags do
        get "", action: :index
        get :recent
        get :show
        post :add_related_tag
        post :destroy_related_tag
      end
      namespace :search do
        get "", action: :index
        get :article
        get :comment
        get :profile
        get :tag
      end
      resources :feeds, only: :index
      resources :messages, except: :update do
        collection do
          get :contacts
        end
      end
      resources :surveys, except: [:index, :update] do
        member do
          post :vote
        end
      end
      resources :activities, only: :index
    end
  end
  namespace :files do
    get "/profile_images/:username", action: :show_profile_image
    get "/:key/:file", action: :show, file: /.*/
  end
  get "/File/Download.aspx", to: "files#show_legacy"
end
