Happimetrics::Application.routes.draw do
  # root dashboard path
  root :to => 'dashboard', :action => 'index'

  # metrics administration
  resources :metrics

  # breakdowns
  # days
  match "/day/:day/:month/:year" => "dashboard#show", :type => :day, :as => "day"
  # weeks
  match "/week/:day/:month/:year" => "dashboard#show", :type => :week, :as => "week"


end
