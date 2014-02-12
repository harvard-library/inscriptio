Inscriptio::Application.routes.draw do
  resources :emails do
    collection do
      get 'asset_type'
    end
  end

  resources :school_affiliations

  resources :messages do
    collection do
      get 'help'
    end
  end

  resources :reports, :only => ['index'] do
    collection do
      get 'active-assets', :to => 'reports#active_assets'
      get 'user-types', :to => 'reports#user_types'
    end
  end

  resources :reservation_notices do
    collection do
      put 'reset_notices'
    end
  end

  devise_for :users

  resources :users do
    member do
      get 'reservations'
    end
    collection do
      post 'import'
      get 'export'
    end
  end

  resources :moderator_flags

  resources :posts, :except => [:index]

  resources :bulletin_boards

  resources :user_types, :except => [:new]

  resources :reservations do
    member do
      put 'approve'
    end
  end


  resources :search

  resources :reservable_assets do
    member do
      get 'locate'
    end
    collection do
      post 'import'
    end

  end

  resources :reservable_asset_types

  resources :call_numbers

  resources :subject_areas

  resources :libraries do
    resources :floors do
      member do
        post 'move_higher'
        post 'move_lower'
        get 'assets'
      end
    end
    resources :user_types
  end

  root :to => 'libraries#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
