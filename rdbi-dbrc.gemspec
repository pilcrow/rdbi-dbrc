# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rdbi-dbrc}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Erik Hollensbe"]
  s.date = %q{2010-12-10}
  s.description = %q{Implementation of dbi-dbrc for RDBI}
  s.email = %q{erik@hollensbe.org}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/rdbi-dbrc.rb",
    "rdbi-dbrc.gemspec",
    "test/dbrc",
    "test/helper.rb",
    "test/test_dbrc.rb"
  ]
  s.homepage = %q{http://github.com/erikh/rdbi-dbrc}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Implementation of dbi-dbrc for RDBI}
  s.test_files = [
    "test/helper.rb",
    "test/test_dbrc.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rdbi>, [">= 0"])
      s.add_development_dependency(%q<rdbi-driver-mock>, [">= 0"])
      s.add_development_dependency(%q<test-unit>, [">= 0"])
    else
      s.add_dependency(%q<rdbi>, [">= 0"])
      s.add_dependency(%q<rdbi-driver-mock>, [">= 0"])
      s.add_dependency(%q<test-unit>, [">= 0"])
    end
  else
    s.add_dependency(%q<rdbi>, [">= 0"])
    s.add_dependency(%q<rdbi-driver-mock>, [">= 0"])
    s.add_dependency(%q<test-unit>, [">= 0"])
  end
end
