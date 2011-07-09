Rails.application.routes.draw do
  match 'rdtable/:model/:columns' => 'datatables#dataset', :as => 'datatable'
  match 'rdtable/:model/:columns/:scope' => 'datatables#dataset', :as => 'datatable'
  match 'rdtable/:model/:columns/:scope/:id' => 'datatables#dataset', :as => 'datatable'
end