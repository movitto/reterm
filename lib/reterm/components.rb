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

# ncurses
require 'reterm/components/menu'

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
require 'reterm/components/scroll_list'
require 'reterm/components/select_list'
require 'reterm/components/entry'
require 'reterm/components/matrix'
require 'reterm/components/drop_down_menu'
require 'reterm/components/button_box'
require 'reterm/components/alphalist'
require 'reterm/components/multi_line_entry'
require 'reterm/components/histogram'
require 'reterm/components/scrolling_area'

# additional
require 'reterm/components/cmd_output'
require 'reterm/components/youtube'
