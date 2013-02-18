# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oryx/version'

Gem::Specification.new do |gem|
  gem.name          = "oryx"
  gem.version       = Oryx::VERSION
  gem.authors       = ["Casey Robinson"]
  gem.email         = ["kc@rampantmonkey.com"]
  gem.description   = %q{C-Flat to x86 compiler}
  gem.summary       = %q{Take a program written in C-Flat and convert it to x86 assembly}
  gem.homepage      = "rampantmonkey.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake', '~>0.9.2.2'
  gem.add_development_dependency 'shoulda', '~>3.3.2'
  gem.add_dependency 'rltk', '~>2.2.1'
  gem.add_dependency 'colorize', '~>0.5.8'
end
