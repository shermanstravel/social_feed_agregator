# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'social_feed_agregator/version'

Gem::Specification.new do |spec|
  spec.name          = "social_feed_agregator"
  spec.version       = SocialFeedAgregator::VERSION
  spec.authors       = ["Eugene Sobolev"]
  spec.email         = ["eus@appfellas.co"]
  spec.description   = %q{Social Feed Agregator}
  spec.summary       = %q{Social Feed Agregator}
  spec.homepage      = "http://appfellas.nl"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  # the faraday gem is being added with this specific version
  # to avoid the issue bundler is having to find a compatible version
  # to all gems that depend on faraday. It may be removed in the future
  # when he stops doing that.
  spec.add_dependency("rest-client", "1.6.7")
  spec.add_dependency("faraday", "0.8.9")
  spec.add_dependency("instagram", "~> 0.8")
  spec.add_dependency("koala", "~> 2.0")
  spec.add_dependency("tumblr_client", "~> 0.8.2")
  spec.add_dependency("twitter", "~> 5.0.0")
  spec.add_dependency("nokogiri", "~> 1.5")
  spec.add_dependency("json", "~> 1.8.0")
  spec.add_dependency("twitter-text", "~> 1.6.1")
end
