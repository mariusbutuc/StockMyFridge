StockMyFridge::Application.routes.draw do
  resources :groceries, :stores

  # root :to => "welcome#index"
end
