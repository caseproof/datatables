module Datatables
  require 'datatables/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'datatables/activerecord_methods' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'datatables/datatable_helpers' if defined?(Rails) && Rails::VERSION::MAJOR == 3
end
