Rails.application.routes.draw do
  
  devise_for :parents, controllers: {
    confirmations: 'parents/confirmations',
    registrations: 'parents/registrations',
    sessions: 'parents/sessions',
    passwords: 'users/passwords'  
  }
  
  devise_for :students, controllers: {
    confirmations: 'students/confirmations',
    registrations: 'students/registrations',
    sessions: 'students/sessions',
    passwords: 'users/passwords'
  }
  
  get 'cases', to: 'cases#index'
  get 'sentences', to: 'sentences#index' 
  
  devise_scope :students do
    get  "/student/current_record", to: "students/student_current_records#index"
    post "/student/update_current_record", to: "students/student_current_recrods#update"
    
    get  "/student/learnt_components", to: "students/student_learnt_components#index"
    post "/student/learnt_components", to: "students/student_learnt_components#create"
    post "/student/update_learnt_components", to: "students/student_learnt_components#update"
    
    get  "/student/learnt_words", to: "students/student_learnt_words#index"
    post "/student/learnt_words", to: "students/student_learnt_words#create"
    post "/student/update_learnt_words", to: "students/student_learnt_words#update"
  end
  
  root to: "home#index"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
