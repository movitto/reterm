lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reterm/version'

SUMMARY     = 'All RETerm Dependencies'

DESCRIPTION = 'This metagem pulls in reterm and all optional dependencies for '\
              'full functionality'

# 'All' Gem includes reterm and all optional dependencies
Gem::Specification.new do |spec|
  spec.name          = 'reterm-all'
  spec.version       = RETerm::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Mo Morsi']
  spec.email         = ['mo@morsi.org']
  spec.has_rdoc      = false
  spec.homepage      = 'http://github.com/movitto/reterm'
  spec.summary       = SUMMARY
  spec.description   = DESCRIPTION
  spec.license       = "MIT"

  spec.add_dependency 'reterm',     "= #{RETerm::VERSION}"
  spec.add_dependency 'cdk',        '~> 0.10'
  spec.add_dependency 'artii',      '~> 2.1'
  spec.add_dependency 'drawille',   '~> 0.3'
  spec.add_dependency 'chunky_png', '~> 1.3'
end
