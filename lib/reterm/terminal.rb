module RETerm
  # Provides helper mechanisms which to retrieve terminal
  # information (dimensions, etc)
  class Terminal
    def self.reset!
      @dimensions = nil
    end

    def self.dimensions
      require 'terminfo'
      @dimensions ||= TermInfo.screen_size
    end

    def self.load(min = nil)
      dimensions
      raise ArgumentError, "Terminal too Small - min: #{min}" if min &&
                                                         (cols < min[:cols] ||
                                                          rows < min[:rows])
      nil
    end

    def self.cols
      dimensions[1]
    end

    def self.rows
      dimensions[0]
    end

    def self.contains?(r, c)
      r < rows && c < cols
    end

    def self.resize!
      Window.top.each { |w|
        w.dispatch :resize
      }
    end
  end # class Terminal
end # module RETerm
