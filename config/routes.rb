# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".
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

  resources :reservation_notices, :except => [:new, :create, :destroy] do
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

  resources :posts, :except => [:index] do
    resources :moderator_flags, :shallow => true, :except => [:index, :show, :edit]
  end

  # All manipulation of BB state is directly through the model
  #  in the reservable_assets_controller (yuck)
  resources :bulletin_boards, :only => [:show]

  resources :user_types, :except => [:new]

  resources :reservations do
    member do
      put 'approve'
      put 'expire'
      put 'renew'
    end
  end

  # Most of the infrastructure for this exists, but it's not subject to auth,
  # and needs substantial work to be sane.  Therefore, commented until safe

  # resources :search

  resources :reservable_asset_types, :only => [:index] do
    resources :reservable_assets, :shallow => true
  end

  resources :reservable_assets, :only => [] do
    member do
      get 'locate'
    end
    collection do
      post 'import'
    end
  end

  resources :libraries do
    resources :floors, :except => [:index] do
      member do
        post 'move_higher'
        post 'move_lower'
        get 'assets'
      end
    end
    resources :subject_areas, :shallow => true do
      resources :call_numbers, :shallow => true
    end
    resources :call_numbers, :shallow => true
    resources :user_types
    resources :reservable_asset_types, :except => [:index]
  end

  resources 'subject_areas', :only => [:index]
  resources 'call_numbers', :only => [:index]

  root :to => 'libraries#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Example of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Example of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
