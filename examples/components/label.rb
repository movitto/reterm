require 'reterm'
include RETerm

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 30
  win.border!
  update_reterm

  label = Components::Label.new :text => "Please wait 3 seconds..."
  win.component = label
  label.draw!

  sleep(3)
}
