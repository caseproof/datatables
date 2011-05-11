require 'rails'
require 'active_record/base'
require 'datatables'

module Datatables
  class Engine < Rails::Engine
    config.autoload_paths += %W(#{config.root})
  end
end
