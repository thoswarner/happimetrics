Happimetrics::Application.routes.draw do
  # root dashboard path
  root :to => 'dashboard', :action => 'index'

  # metrics administration
  resources :metrics

  # breakdowns
  [:day, :week, :month, :year].each do |type|
    params = case type
    when :day, :week
      "/:day/:month/:year"
    when :month
      "/:month/:year"
    when :year
      "/:year"
    end
    match "/#{type.to_s}#{params}" => "dashboard#show", :type => type, :as => type.to_s
  end

end
