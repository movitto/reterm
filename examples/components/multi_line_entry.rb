require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 7,
                   :cols => 30
  win.border!
  update_reterm

  entry = Components::MultiLineEntry.new :title => "<C>Enter",
                                         :label => "Text: ",
                                         :rows  => 30
  win.component = entry
  value = entry.activate!
}

puts "Entry Value: #{value}"
