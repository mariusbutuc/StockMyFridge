StockMyFridge::Application.routes.draw do

  resources :groceries, :stores

  root :to => "statics#home"
end
