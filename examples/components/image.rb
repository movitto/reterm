require 'reterm'
include RETerm

file = File.join(File.expand_path(File.dirname(__FILE__)), 'stencil-1.png')

init_reterm {
  win = Window.new :rows => 200,
                   :cols => 200
  win.border!
  update_reterm

  img = Components::Image.new :file => file
  win.component = img
  img.draw!

  sleep(3)
}
