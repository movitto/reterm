require 'set'

module RETerm
  # Defines a pair of colors used for foreground / background
  # rendering associated with id and tag list.
  class ColorPair
    attr_accessor :id
    attr_accessor :tags

    attr_accessor :fg
    attr_accessor :bg

    def self.builtin
      @builtin ||=  Ncurses.constants.select { |c|
                      c =~ /COLOR.*/
                    }.collect { |c|
                      c.to_s.gsub("COLOR_", "").downcase.intern
                    }
    end

    def self.default_bg
      -1
    end

    # Redefined system RGB color. Color name should be specified
    # as well as new RGB components
    #
    # @param [String, Symbol] color name of color to change,
    #   ex "red", "blue", etc
    # @param [Integer] r value to assign to red component
    # @param [Integer] g value to assign to green component
    # @param [Integer] b value to assign to blue component
    def self.change(color, r, g, b)
      Ncurses::init_color Ncurses.const_get("COLOR_#{color.to_s.upcase}"), r, g, b
    end

    # Instantiate a new ColorPair, specifying foreground and background
    # colors as well as any tags.
    #
    # A unique id for this color pair will be autogenerated
    #
    # @param [String, Symbol] fg forground color name
    # @param [String, Symbol] bg background color name
    # @param [Array<String, Symbol>] tags array of tags to assign
    #   to color pair
    def initialize(fg, bg, *tags)
      @@id ||= 0
      @@id  += 1
      @id    = @@id

      @tags = Set.new(tags)

      # FIXME need to verify input is in valid domain
      # before conveRETermng it to symbol w/ "intern"
      fg = fg.to_s.downcase.intern if fg.is_a?(String) || fg.is_a?(Symbol)
      bg = bg.to_s.downcase.intern if bg.is_a?(String) || bg.is_a?(Symbol)

      fgc = fg.is_a?(Symbol) ? Ncurses.const_get("COLOR_#{fg.to_s.upcase}") : fg
      bgc = bg.is_a?(Symbol) ? Ncurses.const_get("COLOR_#{bg.to_s.upcase}") : bg

      Ncurses.init_pair(@id, fgc, bgc)
    end

    # Create and store a new Color Pair in a static
    # registry
    def self.register(fg, bg, *tags)
      @@registry ||= []
      @@registry  << new(fg, bg, *tags)
      @@registry.last
    end

    # Return all colors pairs
    def self.all
      @@registry ||= []
      @@registry
    end

    # Return first Color Pair found with the given tag
    # or nil for no matches
    def self.for(tag)
      @@registry ||= []
      @@registry.find { |cp| cp.tags.include?(tag) }
    end
  end # class ColorPair
end # module RETerm
