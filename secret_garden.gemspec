# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'secret_garden/version'

Gem::Specification.new do |spec|
  spec.name          = "secret_garden"
  spec.version       = SecretGarden::VERSION
  spec.authors       = ["Derek Kastner"]
  spec.email         = ["dkastner@gmail.com"]

  spec.summary       = %q{Access your 12-factor app secrets securely}
  spec.description   = %q{Provide secrets either via ENV or fall back to secure backends like vault}
  spec.homepage      = "http://github.com/dkastner/secret_garden"

  spec.license = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vault"
end
