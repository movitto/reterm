require 'reterm'
include RETerm

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 50
  update_reterm

  histogram = Components::Histogram.new :title => "Value..."
  win.component = histogram
  histogram.value = 6
  histogram.draw!

  sleep(3)
}
