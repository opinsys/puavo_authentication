# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{puavo_authentication}
  s.version = "0.0.15"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jouni Korhonen"]
  s.date = %q{2011-09-08}
  s.description = %q{Authentication solution for Puavo applications}
  s.email = %q{puavo@opinsys.fi}
  s.extra_rdoc_files = [
    "COPYING",
     "README.rdoc",
     "init.rb"
  ]
  s.files = [
    "COPYING",
     "README.rdoc",
     "app/controllers/sessions_controller.rb",
     "app/views/layouts/sessions.html.erb",
     "app/views/sessions/new.html.erb",
     "init.rb",
     "lib/puavo/authentication.rb",
     "lib/puavo/authorization.rb",
     "lib/puavo/connection.rb",
     "lib/puavo_authentication.rb",
     "lib/puavo_authentication/controllers/helpers.rb",
     "lib/tasks/puavo_ldap_auth.rake",
     "lib/user_error.rb",
     "rails/init.rb"
  ]
  s.homepage = %q{http://github.com/opinsys/puavo_authentication}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Authentication solution for Puavo applications}
  s.test_files = [
    "test/puavo_authentication_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

