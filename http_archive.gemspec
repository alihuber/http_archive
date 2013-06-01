# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http_archive/version'

Gem::Specification.new do |spec|
  spec.name          = "http_archive"
  spec.version       = HttpArchive::VERSION
  spec.authors       = ["Alexander Huber"]
  spec.email         = ["alih83@gmx.de"]
  spec.description   = %q{A library to interact with HTTP Archives (.har files)}
  spec.summary       = %q{Interact with HTTP Archives, loosely following the interface of the Archive::HAR Perl module}
  spec.homepage      = "http://github.com/alihuber/http_archive"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*.rb']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_path = "lib"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency 'json'
end
