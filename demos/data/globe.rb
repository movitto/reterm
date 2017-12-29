require_relative './globes'

# Spinning Globe Widget
module RETerm
  module Components
    class Globe < Component
      attr_accessor :marked

      attr_accessor :dir

      SYMBOLS = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")",
                 "-", "+", "_", "=", "?", "/", "\\", "{", "}", "[", "]",
                 ">", "<", ".", ":", ";"]

      def initialize(args={})
        activate_sync!

        @marked = args[:marked] || []
        @dir    = args[:dir]    || :left
        @angle  = 0

        @colors  = {}
        @symbols = {}

        @current_color  = -1
        @current_symbol = -1
      end

      def requested_rows
        30
      end

      def requested_cols
        100
      end

      def sync!
        # TODO incorporate :speed param into angle update
        # (record elapsed time locally?)
        @angle += 1
        draw!
      end

      def draw!
        refresh_win
      end

      def left?
        @dir == :left
      end

      def <<(mark)
        @marked << mark
        self
      end

      def color_for(mark)
        return @colors[mark] if @colors.key?(mark)
        @colors[mark] = next_color
      end

      def symbol_for(mark)
        return @symbols[mark] if @symbols.key?(mark)
        @symbols[mark] = next_symbol
      end

      private

      def next_color
        choices = ColorPair.builtin - [:black, :white]

        @current_color += 1
        @current_color  = 0 if @current_color >= choices.size

        ColorPair.register(choices[@current_color],
                           ColorPair.default_bg)
      end

      def next_symbol
        @current_symbol += 1
        @current_symbol  = 0 if @current_symbol >= SYMBOLS.size
        SYMBOLS[@current_symbol]
      end

      def refresh_win
        window.clear!
        angle = @angle%GLOBES.size * (left? ? -1 : 1)
        deg   = angle.abs.to_f * LONS_PER_ROT
        deg   = deg - 360  if deg > 180
        deg  *= -1 unless left?
        rad   = deg * Math::PI/180
        globe = GLOBES[angle]

        #window.mvaddstr 0, 0, "@ #{deg-LONS_PER_GLOBE/2} > #{deg} (#{rad.round(2)}) > #{deg+LONS_PER_GLOBE/2}"
        globe.each_with_index { |l, li|
          window.mvaddstr li, 0, l
        }

        refresh_marks(globe, deg)
        update_reterm
      end


      def refresh_marks(globe, deg)
        rad = deg * Math::PI/180 # XXX recalc

        max_col = globe.max { |l1, l2|
                    l1.size <=> l2.size
                  }.size

        center_col = max_col/2

        max_row    = globe.size.to_f
        center_row = max_row / 2

        lpl = 180 / max_row                 # lats per line
        lpc = LONS_PER_GLOBE.to_f / max_col # lons per col

        @marked.each { |mark|
          i = (mark.first < (deg + LONS_PER_GLOBE/2) &&
               mark.first > (deg - LONS_PER_GLOBE/2))

          if i
            mline = center_row - mark.last.to_f / 90 * max_row/2
            mang  = mark.first.to_f / 180 * Math::PI
            maang = mang - rad
            mcol  = center_col+Math.cos(maang-Math::PI/2)/lpc*max_col

            cp  = color_for(mark)
            sym = symbol_for(mark)

            # set / unset color pair
            window.win.attron(NC::COLOR_PAIR(cp.id))
            window.win.attron(NC::A_BOLD)
            window.win.mvaddstr mline, mcol, sym
            window.win.attroff(NC::COLOR_PAIR(cp.id))
            window.win.attroff(NC::A_BOLD)
          end
        }
      end
    end # class Globe
  end # module Components
end # module RETerm
