require 'reterm'
include RETerm

init_reterm {
  win = Window.new :rows => 20,
                   :cols => 50
  win.border!

  menu = Menu.new :save => 0,
                  :quit => 1

  menu.attach_to win
  update_reterm

  term = false
  while !term
    c = win.getch
    case c
    when NC::KEY_DOWN
      menu.drive :down
    when NC::KEY_UP
      menu.drive :up
    when NC::KEY_ENTER
    when 10 # line feed
      term = true
      menu.detach
    end
    update_reterm
  end
}
