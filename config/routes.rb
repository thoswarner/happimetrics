Happimetrics::Application.routes.draw do
  root :to => 'dashboard', :action => 'index'

  resources :metrics

end
