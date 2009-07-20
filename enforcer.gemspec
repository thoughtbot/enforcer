# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{enforcer}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Quaranto"]
  s.date = %q{2009-07-20}
  s.default_executable = %q{enforcer}
  s.email = %q{nquaranto@thoughtbot.com}
  s.executables = ["enforcer"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/enforcer",
     "enforcer.gemspec",
     "features/manage_collaborators.feature",
     "features/step_definitions/enforcer_steps.rb",
     "features/support/env.rb",
     "lib/enforcer.rb",
     "lib/repository.rb",
     "test/enforcer_test.rb",
     "test/integration.rb",
     "test/repository_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/thoughtbot/enforcer}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{A simple way to manage permissions on GitHub}
  s.test_files = [
    "test/enforcer_test.rb",
     "test/integration.rb",
     "test/repository_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
