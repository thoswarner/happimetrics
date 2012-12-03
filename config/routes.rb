Happimetrics::Application.routes.draw do
  # root dashboard path
  root :to => 'dashboard', :action => 'index'

  # metrics administration
  resources :metrics

  # days breakdown
  match "/day/:day/:month/:year" => "dashboard#show", :type => :day, :as => "day"


end
