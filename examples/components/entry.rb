require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 30
  win.border!
  update_reterm

  entry = Components::Entry.new :title => "<C>Enter", :label => "Text: "
  win.component = entry
  value = entry.activate!
}

puts "Entry Value: #{value}"
