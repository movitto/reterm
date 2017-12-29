require 'csv'

NUM_LOCS = 5

# parse location file
# sample-worldcities-basic from https://simplemaps.com/data/world-cities
CITIES_FILE = File.join(File.expand_path(File.dirname(__FILE__)),
                           './simplemaps-worldcities-basic.csv')

csv = CSV.read(CITIES_FILE, :headers => true)

###

require 'reterm'
include RETerm

require_relative './globe'
require_relative './weather_info'

init_reterm {
  win     = Window.new
  layout1 = Layouts::Grid.new
  win.component = layout1

  menus = [{"File"  => nil,
            "Quit"  => :quit},
           {"Help"  => nil,
            "About" => :about}]

  menu = Components::DropDown.new :menus => menus
  layout1.add_child :component => menu,
                    :x => 1, :y => 1

  menu.handle(:deactivated) do
    next unless menu.normal_exit?

    if menu.selected == :about
      dwin   = Window.new
      dialog = Components::Dialog.new(:message => "TODO")
      dwin.component = dialog
      dialog.activate!

    elsif menu.selected == :quit
      shutdown!
    end
  end

  layout2 = Layouts::Horizontal.new
  layout1.add_child :component => layout2,
                    :x => 1, :y => 3

  globe = Components::Globe.new
  layout2.add_child :component => globe

  locs = Components::ScrollList.new
  layout2.add_child :component => locs
 # ... set locs rows (fill window) & cols (remaining area)

  # Render n random locations on locs/globe
  0.upto(NUM_LOCS-1) do
    c = csv[rand(csv.size-1)]
    globe << [c["lng"].to_f, c["lat"].to_f]

    # TODO tie locs colors to globe colors
    locs  << (c["city"] + "," + c["province"])
  end

  locs.handle("selected") do
    loc = locs_win.selected
    weather_popup = Components::WeatherInfo.new :loc    => loc,
                                                :parent => win

    button_box = ButtonBox.new :widget => weather_popup,
                               :title  => "Weather for #{loc}"

    weather_popup.activate!
  end

  win.activate!
}
