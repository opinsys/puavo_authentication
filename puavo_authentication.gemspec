# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "puavo_authentication"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jouni Korhonen"]
  s.date = "2012-10-16"
  s.description = "Authentication solution for Puavo applications"
  s.email = "puavo@opinsys.fi"
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
  s.homepage = "http://github.com/opinsys/puavo_authentication"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Authentication solution for Puavo applications"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

