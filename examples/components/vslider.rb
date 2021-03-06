require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 30
  win.border!
  update_reterm

  slider = Components::VSlider.new
  win.component = slider
  value = slider.activate!
}

puts "Slider Value: #{value}"
