require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 10
  win.border!
  update_reterm

  dial = Components::Dial.new
  win.component = dial
  value = dial.activate!
}

puts "Dial Value: #{value}"
