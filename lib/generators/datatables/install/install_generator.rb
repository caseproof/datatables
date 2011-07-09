require 'rails'

module Datatables
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      @@datatables_version = "1.7.5"

      desc "This generator installs the jQuery plugin datatables #{@@datatables_version} and the accompanying default css files."
      source_root File.expand_path('../../../../../vendor/assets', __FILE__)

      def copy_datatable
        say_status("copying", "Datatable (#{@@datatables_version}) JS File", :green)
        copy_file "javascripts/jquery.dataTables.min.js", "public/javascripts/jquery.dataTables.min.js"
        
        say_status("copying", "Datatable CSS Files", :green)
        copy_file "stylesheets/datatable_page.css", "public/stylesheets/datatable_page.css"
        copy_file "stylesheets/datatable_table.css", "public/stylesheets/datatable_table.css"
      end
    end
  end
end