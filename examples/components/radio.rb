require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 30
  win.border!
  update_reterm

  radio = Components::Radio.new :items => ['A', 'B', 'C']
  win.component = radio
  value = radio.activate!
}

puts "Radio Value: #{value}"
