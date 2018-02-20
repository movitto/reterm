require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new
  label = Components::Label.new :text => "Press any key to continue"
  win.component = label
  win.draw!

  i = 0
  label = Components::Label.new :text => i.to_s + "..."

  Components::Splash.show(:widget => label,
                          :rows   => 20,
                          :cols   => 30,
                          :x      => 10,
                          :y      => 10) {
    i += 1
    label.text = i.to_s + "..."
    i > 10
  }

  ch = win.sync_getch
}
