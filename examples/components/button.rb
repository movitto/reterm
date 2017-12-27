require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 3,
                   :cols => 13
  win.border!
  update_reterm

  button = Components::Button.new :title => "Click Me!"
  win.component = button
  value = button.activate!
}

puts "Button Value: #{value}"
