module RETerm
  # JSON schema loader, instantiates RETerm subsystem from schema
  # stored in a JSON string. Currently this schema does not have a
  # formal definition, but see examples/ for what can currently be
  # done.
  class Loader
    # Initialie new loader from JSON string
    def initialize(str)
      require 'json'
      parse_doc(str)
    end

    # Return top level window in loader
    def window
      @win
    end

    private

    def parse_doc(str)
      @j = JSON.parse(str)

      raise ArgumentError unless @j.is_a?(Hash)
      raise ArgumentError unless @j.key?("window")

      parse_colors(@j['colors']) if @j.key?('colors')

      @win = parse_win(@j['window'])
      update_reterm
    end

    def parse_colors(colors)
      raise ArgumentError unless colors.is_a?(Array)
      colors.each { |c|
        raise ArgumentError unless c.is_a?(Array) && c.size >= 3
        ColorPair.register(*c)
      }
    end

    def parse_win(win)
      raise ArgumentError unless win.is_a?(Hash)

      args = {}

      args[:rows] = win['rows'] if win.key?('rows')
      args[:cols] = win['cols'] if win.key?('cols')

      w = Window.new args
      parse_child(w, win)

      w.border! if win.key?('border') && !!win['border']
      w.colors = ColorPair.for(win['colors']) if win.key?('colors')

      w
    end

    def parse_child(win, parent)
      raise ArgumentError if  parent.key?('component') &&  parent.key?('layout')
      raise ArgumentError if !parent.key?('component') && !parent.key?('layout')

      if parent.key?('component')
        parse_component win, parent['component']

      else # if parent.key?('layout')
        parse_layout win, parent['layout']
      end
    end

    def prep_init(init)
      raise ArgumentError unless init.is_a?(Hash)
      init = Hash[init] # make copy

      init.keys.each { |k|
        init[k.intern] = init[k] # XXX unsafe intern
        init.delete(k)
      }

      init
    end

    def parse_component(win, c)
      raise ArgumentError unless c.is_a?(Hash)
      raise ArgumentError unless c.key?("type") ||
                                !Components.names.include?(c["type"])

      init = c.key?("init") ? prep_init(c["init"]) : {}
      c = RETerm::Components.const_get(c["type"]).new(init)
      win.component = c
      c
    end

    def parse_layout(win, l)
      raise ArgumentError unless l.is_a?(Hash)
      raise ArgumentError unless l.key?("type") ||
                                !Layouts.names.include?(l["type"])

      init = l.key?("init") ? prep_init(l["init"]) : {}
      lc = RETerm::Layouts.const_get(l["type"]).new(init)
      win.component = lc
      parse_layout_children(lc, l["children"]) if l.key?("children")
      lc
    end

    def parse_layout_children(l, children)
      raise ArgumentError unless children.is_a?(Array)

      children.each { |child|
        raise ArgumentError unless child.is_a?(Hash)
        rows = child['rows'] if child.key?('rows')
        cols = child['cols'] if child.key?('cols')

        cw = l.add_child :rows => rows,
                         :cols => cols

        cw.border! if child.key?('border') && !!child['border']
        cw.colors = ColorPair.for(child['colors']) if child.key?('colors')

        cw.component = parse_child(cw, child)
      }
    end
  end # class Loader

  def load_reterm(str)
    Loader.new(str).window
  end
end # module RETerm
