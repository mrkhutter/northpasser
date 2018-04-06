# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'northpasser/version'

Gem::Specification.new do |spec|
  spec.name          = "northpass"
  spec.version       = Northpasser::VERSION
  spec.authors       = ["Mark Hutter"]
  spec.email         = ["mrkhutter@gmail.com"]

  spec.summary       = %q{A lightweight ruby wrapper for the Northpass API: https://northpass.com/api/v1}
  spec.homepage      = "https://github.com/mrkhutter/northpass"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "dotenv", "~> 2.1"
  spec.add_development_dependency "webmock", "~> 2.1"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "pry"
end
