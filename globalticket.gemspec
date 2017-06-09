# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'globalticket/version'

Gem::Specification.new do |spec|
  spec.name          = "globalticket"
  spec.version       = Globalticket::VERSION
  spec.authors       = ["Henk Meijer"]
  spec.email         = ["hmeijer@eskesmedia.nl"]

  spec.summary       = %q{Ruby implementation of the Global Ticket Reseller API}
  spec.description   = %q{Ruby implementation of the Global Ticket Reseller API}
  spec.homepage      = "https://github.com/henkm/globalticket"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
