Rails.application.routes.draw do

  devise_for :users

  root 'hosted_site_generator#new_site'
  post 'hosted_site_generator/choose_template_and_features' => 'hosted_site_generator#choose_template_and_features'
  get 'hosted_site_generator/payment_plan' => 'hosted_site_generator#payment_plan'
  post 'hosted_site_generator/create_site' => 'hosted_site_generator#create_site'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
