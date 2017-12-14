require 'reterm'
include RETerm

value = nil

init_reterm {
  win = Window.new :rows => 50,
                   :cols => 60
  win.border!
  update_reterm

  matrix = Components::Matrix.new :title => 'The Matrix Has You',
                                  :rows => 3, :cols => 5
                                  #:rows  => ['R1', 'R2'],
                                  #:cols  => ['C1', 'C2']
  win.component = matrix
  matrix.activate!
  value = matrix.get(1, 1)
}

puts "First Value: #{value}"
