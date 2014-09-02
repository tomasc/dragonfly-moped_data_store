# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dragonfly/moped_data_store/version'

Gem::Specification.new do |spec|
  spec.name          = "dragonfly-moped_data_store"
  spec.version       = Dragonfly::MongoidDataStore::VERSION
  spec.authors       = ["Tomas Celizna"]
  spec.email         = ["tomas.celizna@gmail.com"]
  spec.summary       = %q{Dragonfly data store that uses Moped::GridFS.}
  spec.description   = %q{Dragonfly data store that uses Moped::GridFS.}
  spec.homepage      = "https://github.com/tomasc/dragonfly-moped_data_store"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "dragonfly", "~> 1.0"
  spec.add_dependency "moped", "~> 2.0"
  spec.add_dependency "moped-gridfs"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "rake"
end
