require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 30
  win.border!
  update_reterm

  list = Components::AlphaList.new :title => "Select Item",
                                   :items => ['D', 'Z', 'B']
  win.component = list
  value = list.activate!
}

puts "List Value: #{value}"
