ActionController::Routing::Routes.draw do |map|
  map.connect '/stealth/toggle', :controller => 'stealth', :action => 'toggle'
end
