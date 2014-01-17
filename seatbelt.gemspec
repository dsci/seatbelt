# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seatbelt/version'

Gem::Specification.new do |spec|
  spec.name          = "seatbelt"
  spec.version       = Seatbelt::VERSION
  spec.authors       = ["Daniel Schmidt"]
  spec.email         = ["dsci@code79.net"]
  spec.description   = %q{Tool to define implementation interfaces that should be decoupled from their
implementations. (A Ruby header file approach.)}
  spec.summary       = %q{Define headers in your Ruby (we try to)}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "virtus", "~> 1.0.0"
  spec.add_runtime_dependency "activemodel"
end
