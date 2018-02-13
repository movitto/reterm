# Demo Using launchpad.rb to visually map a novation launchpad to the terminal

module RETerm
  module Components
    class LPGrid < Component
      include EventDispatcher

      def initialize(args={})
        require 'launchpad'

        @grid = Array.new(8) { Array.new(8) { false } }
        @cols = Array.new(8) { 0 }
        @rows = Array.new(8) { 0 }

        colors = ColorPair.reserve(16)
        ColorPair.define colors[0], 255, 255, 255 # red off  green off
        ColorPair.define colors[1],  85,     0, 0 # red low  green off
        ColorPair.define colors[2],  170,    0, 0 # red mid  green off
        ColorPair.define colors[3],  255,    0, 0 # red high green off
        ColorPair.define colors[4],  0,     85, 0 # red off  green low
        ColorPair.define colors[5],  85,    85, 0 # red low  green low
        ColorPair.define colors[6],  170,   85, 0 # red mid  green low
        ColorPair.define colors[7],  255,   85, 0 # red high green low
        ColorPair.define colors[8],  0,    170, 0 # red off  green min
        ColorPair.define colors[9],  85,   170, 0 # red low  green min
        ColorPair.define colors[10], 170,  170, 0 # red mid  green min
        ColorPair.define colors[11], 255,  170, 0 # red high green min
        ColorPair.define colors[12], 0,    255, 0 # red off  green high
        ColorPair.define colors[13], 85,   255, 0 # red low  green high
        ColorPair.define colors[14], 170,  255, 0 # red mid  green high
        ColorPair.define colors[15], 255,  255, 0 # red high green high

        ColorPair.register colors[0],  ColorPair.default_bkgd, "r0g0"
        ColorPair.register colors[1],  ColorPair.default_bkgd, "r1g0"
        ColorPair.register colors[2],  ColorPair.default_bkgd, "r2g0"
        ColorPair.register colors[3],  ColorPair.default_bkgd, "r3g0"
        ColorPair.register colors[4],  ColorPair.default_bkgd, "r0g1"
        ColorPair.register colors[5],  ColorPair.default_bkgd, "r1g1"
        ColorPair.register colors[6],  ColorPair.default_bkgd, "r2g1"
        ColorPair.register colors[8],  ColorPair.default_bkgd, "r0g2"
        ColorPair.register colors[9],  ColorPair.default_bkgd, "r1g2"
        ColorPair.register colors[10], ColorPair.default_bkgd, "r2g2"
        ColorPair.register colors[11], ColorPair.default_bkgd, "r3g2"
        ColorPair.register colors[12], ColorPair.default_bkgd, "r0g3"
        ColorPair.register colors[13], ColorPair.default_bkgd, "r1g3"
        ColorPair.register colors[14], ColorPair.default_bkgd, "r2g3"
        ColorPair.register colors[15], ColorPair.default_bkgd, "r3g3"

        # TODO option for on/off glifs
      end

      def interaction
        @interaction ||= Launchpad::Interaction.new
      end

      def requested_rows
        11
      end

      def requested_cols
        11
      end

      # Overridable, called when x/y button is released
      def on_up(a)
      end

      # Overridable, called when x/y button is pressed
      def on_down(a)
      end

      def activate!
        wire_up_interaction
        refresh_win
        interaction.start
      end

      def stop!
        interaction.stop
      end

      private

      BUTTONS = [
        :grid, :up, :down,
        :left, :right, :session,
        :user1, :user2, :mixer,
        :scene1, :scene2, :scene3, :scene4,
        :scene5, :scene6, :scene7, :scene8
      ]

      COLS = [
        :up, :down, :left, :right,
        :session, :user1, :user2, :mixer,
      ]

      ROWS = [
        :scene1, :scene2, :scene3, :scene4,
        :scene5, :scene6, :scene7, :scene8
      ]

      def wire_up_interaction
        lpg = self

        BUTTONS.each { |b|
          interaction.response_to(b, :up) { |i, a|
            if a[:type] == :grid
                   cycle_grid(a[:x], a[:y])
              set_device_grid(a[:x], a[:y])

            elsif COLS.include?(a[:type])
              c = COLS.index(a[:type])
              cycle_col(c)
              set_device_col(c)

            else # scenes
              r = ROWS.index(a[:type])
              cycle_row(r)
              set_device_row(r)
            end

            refresh_win

            lpg.dispatch :up, a
            on_up a
          }

          interaction.response_to(b, :down) { |i, a|
            lpg.dispatch :down, a
            on_down a
          }
        }
      end

      def cycle_grid(x, y)
        @grid[x][y] = !@grid[x][y]
      end

      def set_device_grid(x, y)
        if @grid[x][y]
          interaction.device.change(:grid, :x => x, :y => y,
                                    :red   => @rows[y],
                                    :green => @cols[x])
        else
          interaction.device.change(:grid, :x => x, :y => y,
                                    :red => :off, :green => :off)
        end
      end

      def cycle_col(col)
        @cols[col] += 1
        @cols[col]  = 0 if @cols[col] > 3
      end

      def set_device_col(col)
        interaction.device.change(COLS[col], :green => @cols[col])
      end

      def cycle_row(row)
        @rows[row] += 1
        @rows[row]  = 0 if @rows[row] > 3
      end

      def set_device_row(row)
        interaction.device.change(ROWS[row], :red => @rows[row])
      end

      def refresh_win
        draw_col_headers
        draw_rows

        window.refresh
        update_reterm
      end

      def draw_col_headers
        @cols.each_with_index { |c, ci|
          cp = ColorPair.for("r0g#{c}").first

          cp.format(window) {
            window.bold! {
              window.mvaddstr(1, ci + 1, c.to_s)
           }
         }
        }
      end

      def draw_rows
        0.upto(@rows.size-1) { |r|
          0.upto(@cols.size-1) { |c|
            cp = ColorPair.for("r#{@rows[r]}g#{@cols[c]}").first

            cp.format(window) {
              window.mvaddstr(r+2, c+1, @grid[c][r] ? [rand(50000)].pack("U*") : " ")
            }
          }

          cp = ColorPair.for("r#{@rows[r]}g0").first
          cp.format(window) {
            window.mvaddstr(r+2, 10, @rows[r].to_s)
          }
        }
      end
    end # class LPGrid
  end # module Components
end # module RETerm
