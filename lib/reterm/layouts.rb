module RETerm
  # Encapsulates all Layouts currently implemented
  module Layouts
    def self.all
      @a ||= Layouts.constants
    end

    def self.names
      @n ||= all.collect { |l| l.to_s }
    end
  end
end

require 'reterm/layout'
require 'reterm/layouts/horizontal'
require 'reterm/layouts/vertical'
require 'reterm/layouts/grid'
