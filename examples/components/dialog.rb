require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 20,
                   :cols => 100
  win.border!
  update_reterm

  dialog = Components::Dialog.new :message => "Popup!"
  win.component = dialog
  dialog = dialog.activate!
}

puts "Dialog Value: #{value}"
