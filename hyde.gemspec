# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hyde/version"

Gem::Specification.new do |s|
  s.name        = "hyde"
  s.version     = Hyde::VERSION
  s.authors     = ["Daniel Nordstrom"]
  s.email       = ["d@nintera.com"]
  s.homepage    = ""
  s.summary     = %q{Your Friendly Neighborhood Jekyll Manager.}
  s.description = %q{A simple control panel for managing your Jekyll powered sites.}

  s.rubyforge_project = "hyde"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rdoc"
  s.add_runtime_dependency "rack"
  s.add_runtime_dependency "warden"
end
