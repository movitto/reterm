require 'reterm'
include RETerm

require_relative './globes'

LEFT = true

# lon, lat
MARK = [-126, -46]

init_reterm {
ColorPair.register :green, :black, :main
cp = NC::COLOR_PAIR(ColorPair.for(:main).id)

  win = Window.new :rows => 50,
                   :cols => 120
  win.border!
  update_reterm

  0.upto(1000) do |i|
    win.clear!

    angle = i%GLOBES.size * (LEFT ? -1 : 1)
    deg   = angle.abs.to_f*LONS_PER_ROT
    deg   = deg - 360  if deg > 180
    deg  *= -1 unless LEFT
    rad   = deg * Math::PI/180

    max_col = GLOBES[angle].max { |l1, l2| l1.size <=> l2.size }.size
    center_col = max_col/2

    max_row    = GLOBES[angle].size.to_f
    center_row = max_row / 2

    lpl = 180 / max_row                 # lats per line
    lpc = LONS_PER_GLOBE.to_f / max_col # lons per col

    win.mvaddstr 0, 0, "@ #{deg-LONS_PER_GLOBE/2} > #{deg} (#{rad.round(2)}) > #{deg+LONS_PER_GLOBE/2}"
    GLOBES[angle].each_with_index { |l, li|
      win.mvaddstr li+1, 0, l
    }

    d = (MARK.first > 0 && deg < 0) ||
        (MARK.first < 0 && deg > 0)

    i = #!d ?
         (MARK.first < (deg + LONS_PER_GLOBE/2)  &&
          MARK.first > (deg - LONS_PER_GLOBE/2))# :
             #(-MARK.first < (deg + LONS_PER_GLOBE/2)  &&
             # -MARK.first > (deg - LONS_PER_GLOBE/2))

    if i
      mline = center_row - MARK.last.to_f / 90 * max_row/2
      mang  = MARK.first.to_f / 180 * Math::PI
      maang = mang - rad
      mcol  = center_col+Math.cos(maang-Math::PI/2)/lpc*max_col

      # set / unset color pair
win.win.attron(cp)
      win.mvaddstr mline, mcol, "!"
win.win.attroff(cp)
    end

    update_reterm

    sleep(0.3)
  end
}
