Rails.application.routes.draw do
mount Judge::Engine => '/judge'

  resources :owners

  resources :units

  resources :vendors do
        collection { post :import }
end

  resources :statuses

resources :sub_categories do
  resources :items
        collection { post :import }

end

resources :categories do
        collection { post :import }
 resources :items
 resources :sub_categories
 collection do
 get 'get_sub_categories', to: "categories#get_sub_categories"
 end
end

get 'tags/:tag', to: 'items#index', as: :tag
  resources :items do
	resources :identifiers
	resources :comments
	resources :vendors
	resources :statuses
	resources :units
	get :autocomplete_sub_category_name, :on => :collection
        get :autocomplete_category_name, :on => :collection
	collection do
	 put :last_seen
	end
	collection do
	 get :edit_multiple
	 put :update_multiple
	end
	collection { post :import }
        member do
        get 'copy'
        end

 get :reset_filterrific, on: :collection
end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
root :to => redirect('/items')
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

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

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
