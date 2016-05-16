# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_cloud_messaging/version'

Gem::Specification.new do |spec|
  spec.name          = "google_cloud_messaging"
  spec.version       = GoogleCloudMessaging::VERSION
  spec.authors       = ["Bernt Habermeier"]
  spec.email         = ["bernie@wannago.com"]
  spec.summary       = %q{Use Google Cloud Messaging API, using Typhoeus.  Very simple. }
  spec.description   = %q{This is a very small wrapper aroudn Typhoeus that manages a call out to GCM.}
  spec.homepage      = "https://github.com/habermeier/google-cloud-messaging"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
