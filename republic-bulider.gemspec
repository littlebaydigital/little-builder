lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'republic-builder/version'

Gem::Specification.new do |s|
  s.name        = 'republic-builder'
  s.date        = Date.today.to_s
  s.version     = RepublicBuilder::VERSION
  s.summary     = "RepublicWealth Build scripts"
  s.description = "RepublicWealth Build scripts, Yeah!"
  s.authors     = ["Republic Wealth Management"]
  s.email       = 'engineers@trunkplatform.com'
  s.files       = Dir["lib/**/*.rb", "lib/**/*.rake"]
  s.homepage    = 'https://github.com/republicwealth/republic-builder'
  s.license     = 'Proprietary'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.required_ruby_version = '~> 2.0'

  s.add_dependency('open_uri_redirections', '~> 0.2')
  s.add_dependency('rest-client', '~> 1.8')
  s.add_dependency('colored', '~> 1.2')
  s.add_dependency('rufus-scheduler', '~> 3.1')

  s.required_ruby_version = '>= 2.0'
end