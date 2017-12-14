require 'reterm'
include RETerm

init_reterm {
  win1 = Window.new
  win2 = Window.new

  win1.mvaddstr(1, 1, "WIN1")
  win2.mvaddstr(1, 1, "WIN2")

  panel1 = Panel.new win1
  panel2 = Panel.new win2

  panel2.handle :panel_show {
    win2.mvaddstr(2, 1, "SHOWN")
    update_reterm
  }

  panel1.show
  update_reterm
  sleep(2)

  panel2.show
  sleep(2)
}
