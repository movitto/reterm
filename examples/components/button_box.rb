require 'reterm'
include RETerm

value = nil
evalue = nil

init_reterm {
  win = Window.new :rows => 20,
                   :cols => 100,
                   :x => 50, :y => 20
                   #:x    => :center,
                   #:y    => :center
  update_reterm

  entry = Components::Entry.new :title => "<C>Enter",
                                :label => "Text: "

  bb = Components::ButtonBox.new :title  => "Tab Me!",
                                 :widget => entry
  win.component = bb
  value = bb.activate!
  evalue = entry.value
}

puts "ButtonBox Value: #{value}/#{evalue}"
