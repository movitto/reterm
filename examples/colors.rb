require 'reterm'
include RETerm

init_reterm {
  activate_sync!

  colors = 50.upto(100).to_a
  colors.each { |c|
    r = (rand(255) + rand(255) * (!!rand(2) ? 1 : -1)) / 2
    g = (rand(255) + rand(255) * (!!rand(2) ? 1 : -1)) / 2
    b = (rand(255) + rand(255) * (!!rand(2) ? 1 : -1)) / 2

    ColorPair.define c, r, g, b
  }

  color_pairs = 1.upto(30).to_a
  color_pairs.each { |cp|
    ColorPair.register rand(colors.size) + 50,
                       rand(colors.size) + 50,
                       "color#{cp}"
  }

  win = Window.new
  win.colors = "color1"

  while win.getch != 'q'.ord
    v = rand(2) == 1

    s = 0.upto(rand(10)).collect { rand(50000) }.pack("U*")
    x = rand(win.cols)
    y = rand(win.rows)

    c = "color#{rand(color_pairs.size-1)+1}"
    win.win.attron(ColorPair.for(c).first.nc)

    if v#ertical
      win.mvaddstr(y, x, s[0])
      s[1..-1].unpack("U*").each_with_index { |c,i|
        win.mvaddstr(y+i, x, [c].pack("U*"))
      }
    else
      win.mvaddstr(y, x, s)
    end

    win.win.attroff(ColorPair.for(c).first.nc)

    update_reterm

    sleep 0.5
  end
}
