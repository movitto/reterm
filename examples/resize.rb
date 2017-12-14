require 'reterm'
include RETerm

init_reterm(:resize => true) {
  win = Window.new :rows => 20,
                   :cols => 50

  win.mvaddstr(1, 1, "Resize the terminal")
  update_reterm

  @block = true

  win.handle :resize {
    win.mvaddstr(1, 1, "Resized!!!!!!!!!!!!!")
    update_reterm
    sleep(3)
    @block = false
  }


  while @block
    sleep(0.1)
  end
}
