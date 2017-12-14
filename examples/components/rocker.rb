require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 30
  win.border!
  update_reterm

  rocker = Components::Rocker.new
  rocker.values = ['First', 'Second', 'Third']
  win.component = rocker
  value = rocker.activate!
}

puts "Rocker Value: #{value}"
