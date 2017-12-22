require 'reterm'
include RETerm

r = nil
init_reterm {
  win = Window.new :rows => 20,
                   :cols => 50
  win.border!

  menu = Components::Menu.new :items => {:save => 0,
                                         :quit => 1}

  menu.window = win
  r = menu.activate!
}

puts "Menu choice #{r}"
