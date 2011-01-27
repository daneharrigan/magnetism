# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "magnetism/version"

Gem::Specification.new do |s|
  s.name        = "magnetism"
  s.version     = Magnetism::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Dane Harrigan"
  s.email       = "dane.harrigan@gmail.com"
  s.homepage    = ""
  s.summary     = %q{A website content management system}
  s.description = %q{A website content management system}

  s.rubyforge_project = "magnetism"

  s.add_dependency 'rails', '~> 3.0.1'
  s.add_dependency 'haml', '~> 3.0.23'
  s.add_dependency 'devise', '~> 1.1.5'
  s.add_dependency 'inherited_resources', '~> 1.1.2'
  s.add_dependency 'layout_options', '~> 0.2.1'
  s.add_dependency 'current_object', '~> 0.2'
  s.add_dependency 'fog', '~> 0.3.34'
  s.add_dependency 'mini_magick', '~> 3.2'
  s.add_dependency 'carrierwave', '~> 0.5.1'
  # will need to add liquify in here...

  s.add_development_dependency 'shoulda', '~> 2.11.3'
  s.add_development_dependency 'rspec', '~> 2.4.0'
  s.add_development_dependency 'rspec-rails', '~> 2.4.1'
  s.add_development_dependency 'database_cleaner', '~> 0.6.0'
  s.add_development_dependency 'factory_girl', '~> 1.3.2'
  s.add_development_dependency 'cover_me', '~> 1.0.0.rc4'
  s.add_development_dependency 'webrat', '~> 0.7.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
