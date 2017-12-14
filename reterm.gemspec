lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reterm/version'

LIB_FILES      = Dir.glob("lib/**/*.rb")
DESIGNER_FILES = Dir.glob("designer/**/*")
EXTRA_FILES    = ["MIT-LICENSE", "README.md"]

FILES          = LIB_FILES      +
                 DESIGNER_FILES +
                 EXTRA_FILES

EXTRA_DEPS = ['artii', 'drawille', 'chunky_png', 'cdk']

###

SUMMARY     = 'Text Based UI Framework built ontop of ncurses'

DESCRIPTION = 'RETerm provides a framework and components to '\
              'build full featured terminal interfaces.'

EXTRA_NOTE1 = "---\nTo use all components, the following additional "\
              "gem dependencies should be installed:\n"

EXTRA_NOTE2 = "\nIf optional dependencies are missing the framework "\
              "will still work but dependent components will fail to load\n---"

DESIGNER_NOTE = 'To use the interface designer you will also need '\
                'to install the \"visualruby\" gem'

POST_INSTALL_MSG = EXTRA_NOTE1           +
                   EXTRA_DEPS.join("\n") +
                   DESIGNER_NOTE         +
                   EXTRA_NOTE2

###

Gem::Specification.new do |spec|
  spec.name          = 'reterm'
  spec.version       = RETerm::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Mo Morsi']
  spec.email         = ['mo@morsi.org']
  spec.has_rdoc      = false
  spec.homepage      = 'http://github.com/movitto/reterm'
  spec.summary       = SUMMARY
  spec.description   = DESCRIPTION
  spec.license       = "MIT"

  spec.require_paths = ['lib']
  spec.files         = FILES

  spec.add_dependency 'ruby-terminfo', '~> 0.1'
  spec.add_dependency 'ncursesw', '~> 1.4' # only tested against 1.4.10, milage 
                                           # may vary with other versions!

  spec.post_install_message = POST_INSTALL_MSG
end
