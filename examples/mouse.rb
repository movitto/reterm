require 'reterm'
include RETerm

class Demo < Component
  include MouseInput

  def on_button(b, evnt, coords)
    window.mvaddstr 1, 0, "Button #{b} #{evnt}, #{coords}"
  end

  def activate!
    window.mvaddstr 0, 0, "Press 'q' to quit"

    while (ch = sync_getch) != 'q'.ord
      process_mouse(ch)
    end
  end
end

init_reterm(:mouse_paste => true){
  win = Window.new
  win.border!
  update_reterm


  component = Demo.new
  win.component = component
  component.activate!
}
