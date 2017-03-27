# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yesgraph/version'

Gem::Specification.new do |spec|
  spec.name          = "yesgraph"
  spec.version       = Yesgraph::VERSION
  spec.authors       = ["Mayank Juneja"]
  spec.email         = ["mayank@yesgraph.com"]

  spec.summary       = %q{Ruby wrapper for YesGraph API}
  spec.description   = %q{Ruby wrapper for YesGraph API}
  spec.homepage      = "https://github.com/YesGraph/ruby-yesgraph"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rest-client", "~> 2.0"
end
