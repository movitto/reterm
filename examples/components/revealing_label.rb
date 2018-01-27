require 'reterm'
include RETerm

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 30
  win.border!
  update_reterm

  label = Components::RevealingLabel.new :text => "Press\nAny\nKey"
  win.component = label
  label.draw!

  win.sync_getch
}
