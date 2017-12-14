module RETerm
  # Encapsulates all the Components which have been
  # currently implemented
  module Components
    def self.all
      @a ||= Components.constants
    end

    def self.names
      @n ||= all.collect { |c| c.to_s }
    end
  end
end

require 'reterm/component'

# custom
require 'reterm/components/dial'
require 'reterm/components/rocker'
require 'reterm/components/vslider'
require 'reterm/components/label'
require 'reterm/components/ascii_text'
require 'reterm/components/image'

# cdk
require 'reterm/components/hslider'
require 'reterm/components/button'
require 'reterm/components/dialog'
require 'reterm/components/radio'
require 'reterm/components/slist'
require 'reterm/components/entry'
require 'reterm/components/matrix'
