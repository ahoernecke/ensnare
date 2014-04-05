Ensnare::Engine.routes.draw do

  get "dashboard/metrics", to: "dashboard#metrics", :as=> 'metrics'
  get "dashboard/mode", to: "dashboard#mode", :as=> 'mode'
  get "dashboard/configuration", to: "dashboard#configs", :as=> 'configs'
  get "dashboard/edit"
  get "dashboard/violations", to: "dashboard#violations"
  
  root to: "violations#redirect", :as=>:redir
  match "violations/captcha", to: "violations#captcha", :as => 'captcha'
  
  post "configuration/change_mode", to: "configuration#change_mode", as: 'change_mode'
  
end
