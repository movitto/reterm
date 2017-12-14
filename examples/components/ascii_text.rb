require 'reterm'
include RETerm

init_reterm {
  win = Window.new :rows => 20,
                   :cols => 120
  win.border!
  update_reterm

  text = Components::AsciiText.new :text => "Please wait...",
                                   :font => "epic"
  win.component = text
  text.draw!

  sleep(3)
}
