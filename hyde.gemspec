# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hyde/version"

Gem::Specification.new do |s|
  s.name        = "hyde"
  s.version     = Hyde::VERSION
  s.authors     = ["Daniel Nordstrom"]
  s.email       = ["d@nintera.com"]
  s.homepage    = ""
  s.summary     = %q{Control panel for Jekyll.}
  s.description = %q{A simple control panel to manage Jekyll powered websites.}

  s.rubyforge_project = "hyde"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "jekyll"
end
