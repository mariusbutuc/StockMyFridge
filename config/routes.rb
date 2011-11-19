StockMyFridge::Application.routes.draw do
  resources :groceries, :ingredients, :recipes, :stores

  root :to => "statics#home"
end
