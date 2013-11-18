# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seatbelt/version'

Gem::Specification.new do |spec|
  spec.name          = "seatbelt"
  spec.version       = Seatbelt::VERSION
  spec.authors       = ["Daniel Schmidt"]
  spec.email         = ["dsci@code79.net"]
  spec.description   = %q{Interface for accessing travel data from TravelIt}
  spec.summary       = %q{A nifty travel gem}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "virtus", "0.5.5"
  spec.add_runtime_dependency "activemodel"
end
