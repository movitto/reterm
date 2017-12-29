require 'csv'

NUM_LOCS = 10

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
  layout2.add_child :component => locs,
                    :expand    => true

  locs << ""
# ... set locs rows (fill window) & cols (remaining area)

  # Render n random locations on locs/globe
  0.upto(NUM_LOCS-1) do
    c = csv[rand(csv.size-1)]
    mark = [c["lng"].to_f, c["lat"].to_f]
    globe << mark

    color = globe.color_for(mark)
    loc = "</#{color.id}>" + c["city"].to_s + "," + c["province"].to_s
    locs << loc
  end

  locs.handle(:deactivated) do
    loc = locs.selected
# ...
    #weather_popup = Components::WeatherInfo.new :loc    => loc,
    #                                            :parent => win

    #button_box = Components::ButtonBox.new :widget => weather_popup,
    #                                       :title  => "Weather for #{loc}"

    #weather_popup.activate!
  end

  win.activate!
}
