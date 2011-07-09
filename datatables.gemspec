# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "datatables"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Blair Williams","Brandon Toone"]
  s.email       = ["blair@caseproof.com","btoone@gmail.com"]
  s.homepage    = "http://blairwilliams.com/ruby-on-rails/datatables"
  s.summary     = %q{Datatables is a Rails 3 plugin that enables the easy creation of dynamic datatable views on top of any ActiveRecord model}
  s.description = %q{Datatables is a Rails 3 plugin that enables the easy creation of dynamic datatable views on top of any ActiveRecord model. Datatables provides a simple helper that can be utilized in the view to automatically display a dynamic view on top of a model. Datatables handles the entire front end and backend support to do this. }

  s.add_dependency('rails','>= 3.0.3')
  s.add_dependency('jquery-rails')
  
  s.license = 'MIT'

  s.rubyforge_project = "datatables"

  s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #s.require_paths = ["app","config","lib"]
end
