require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 5,
                   :cols => 30
  win.border!
  update_reterm

  area = Components::ScrollingArea.new :title => "Ouput"
  win.component = area

  sleep(1)
  area << "Some"

  sleep(1)
  area << "thing"

  sleep(1)
  area << "happend"

  sleep(0.3)
  area << "."

  sleep(0.3)
  area << "."

  sleep(0.3)
  area << "."

  area << "Today"

  sleep(3)
}
