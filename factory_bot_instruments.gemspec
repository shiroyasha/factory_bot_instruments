# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'factory_bot_instruments/version'

Gem::Specification.new do |spec|
  spec.name          = "factory_bot_instruments"
  spec.version       = FactoryBotInstruments::VERSION
  spec.authors       = ["Igor Šarčević"]
  spec.email         = ["igor@renderedtext.com"]

  spec.summary       = %q{Instruments for Factory Bot}
  spec.description   = %q{Instruments for Factory Bot}
  spec.homepage      = "https://github.com/shiroyasha/factory_girl_instruments"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "factory_bot", "~> 5.0"
  spec.add_dependency "activerecord", ">= 4.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3"
end
