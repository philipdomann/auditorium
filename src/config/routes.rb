Auditorium::Application.routes.draw do
  ActiveAdmin.routes(self)

  resources :membership_requests, :only => [:index, :create, :destroy]

  post "membership_requests/create", :to => 'membership_requests#create', :as => :create_membership_request
  match "membership_requests/:id/confirm", :to => 'membership_requests#confirm', :as => :confirm_membership_request
  match "membership_requests/:id/reject", :to => 'membership_requests#reject', :as => :reject_membership_request
  match "membership_requests/:id/add_as_member", :to => 'membership_requests#add_as_member', :as => :add_as_member_membership_request
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, :controllers => { :confirmations => "users/confirmations", :sessions => "users/sessions", :registrations => "users/registrations" }

  resources :feedbacks
  post 'feedbacks/:id/mark_as_read' => 'feedbacks#mark_as_read', :as => :mark_feedback_as_read
  post 'notifications/:id/mark_as_read' => 'notifications#mark_as_read', :as => :mark_notification_as_read
  mathjax 'mathjax'
  
  resources :email_settings
  match 'email_settings/subscriptions', :to => 'email_settings#change_emails_for_subscriptions', :as => :change_email_settings_for_subscriptions

  get "ajax/courses"
  get "ajax/lectures"
  get "ajax/chairs"

  match 'intro', :to => 'landing_page#index'
  match 'home', :to => 'home#index'
  match 'my_faculties', :to => 'my_faculties#index'
  match 'permission_denied', :to => 'applications#permission_denied', :as => :permission_denied

  resources :notifications
  
  resources :faculties
  
  resources :terms
  get 'courses/search', to: 'terms#search_courses', as: :search_courses
  get 'my_courses/search', to: 'terms#search_courses', as: :search_my_courses
  get 'terms/:id/search', to: 'terms#search_courses', as: :search_courses_in_term
  get 'lectures/search', to: 'lectures#search', as: :search_lectures

  controller :search do
    get 'search' => :index, as: :search
  end

  
  get 'users/moderation' => 'users#moderation', :as => :users_moderation
  get 'users/moderation/search', to: 'users#search', as: :search_users
  resources :users
  get 'users/:id/questions' => 'users#questions', :as => :users_questions
  get 'users/:id/answers' => 'users#answers', :as => :users_answers
  match 'users/:id/confirm' => 'users#confirm', :as => :confirm_user
  post 'notifications/mark_all_as_read' => 'notifications#mark_all_as_read', :as => :mark_all_as_read
  post 'notifications/delete_all_notifications' => 'notifications#delete_all_notifications', :as => :delete_all_notifications
  match 'notifications' => 'notifications#index', :as => :notifications_for_course

  resources :courses

  match 'courses/:id/manage_users', :to => 'courses#manage_users', :as => :manage_users
  match 'courses/:id/announcements', :to => 'courses#announcements', :as => :course_announcements
  match 'courses/:id/search_users', to: 'courses#search_users', as: :search_users_to_manage

  match 'courses/search', :to => 'courses#search'
  match 'courses/:id/following', :to => 'courses#following', as: :follow_course
  match 'courses/:id/approve', :to => 'courses#approve', :as => :approve_course
  match 'courses/:id/unfollow', :to => 'courses#following', :unfollow => 'true'

  match 'posts/maintainer_request', :to => 'posts#maintainer_request', :as => :maintainer_request
  post 'posts/:id/convert', :to => 'posts#convert', :as => :convert_post
  match 'posts/:id/rate', :to => 'posts#rate', :as => :rate_post
  match 'posts/:id/answered', :to => 'posts#answered', :as => :answered_post
  match 'posts/:parent_id/answering', :to => 'posts#answering'
  match 'posts/:parent_id/commenting', :to => 'posts#commenting'

  resources :reports

  match '/reports/:id/mark_read', :to => 'reports#mark_read', :as => 'mark_report_as_read'

  resources :course_memberships
  match "my_courses", :to => "course_memberships#index"

  get 'chairs/search', to: 'chairs#search', as: :search_chairs
  resources :chairs
  

  resources :posts do
    get :autocomplete_courses_name, :on => :collection
  end

  resources :reports

  resources :periods

  resources :institutes

  resources :events

  resources :lectures
  
# run "rake db:jexam_sync" instead of GETting an url
#  resources :jexamwebservice

  root to: "landing_page#index"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
