# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-authentication}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["R W Boyer"]
  s.date = %q{2009-04-22}
  s.description = %q{Simple authentication plugin for sinatra using OpenID.}
  s.email = %q{rwboyerjr@gmail.com}
  s.extra_rdoc_files = ["lib/sinatra-authentication.rb", "TODO"]
  s.files = ["lib/sinatra-authentication.rb", "History.txt", "Rakefile", "readme.rdoc", "TODO", "Manifest", "sinatra-authentication.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/rwboyer/sinatra-authentication}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Sinatra-authentication", "--main", "readme.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sinatra-authentication}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple authentication plugin for sinatra using OpenID.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<sinatra>, [">= 0"])
      s.add_development_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<dm-timestamps>, [">= 0"])
      s.add_development_dependency(%q<dm-validations>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<dm-timestamps>, [">= 0"])
      s.add_dependency(%q<dm-validations>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<dm-timestamps>, [">= 0"])
    s.add_dependency(%q<dm-validations>, [">= 0"])
  end
end
