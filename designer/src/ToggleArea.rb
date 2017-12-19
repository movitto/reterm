# Mechanism which user specifies area to add component
class ToggleArea
  attr_accessor :toggled, :designer

  def toggle_on
    @toggled = true
    btn.remove(btn.children[0])
    btn.add(rm)
    @designer.toggle_area = self
  end

  def toggle_off
    @toggled = false
    btn.remove(btn.children[0])
    btn.add(add)
    show
    @designer.clear_toggle_area
  end

  def add
    @add ||= Gtk::Image.new :file => "#{IMG_DIR}/add.png"
  end

  def rm
    @rm ||= Gtk::Image.new :file => "#{IMG_DIR}/remove.png"
  end


  def btn
    @btn ||=
      begin
        b = Gtk::Button.new
        b.add add

        b.signal_connect("clicked") { |*args|
          if @toggled
            toggle_off
          else
            toggle_on
          end

          show
        }

        css_provider = Gtk::CssProvider.new
        css_provider.load(data: "button:hover {background-image: image(#FFFF00);}")
        b.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)

        b.drag_dest_set(Gtk::DestDefaults::ALL | Gtk::DestDefaults::MOTION | Gtk::DestDefaults::HIGHLIGHT,
                        [["reterm", :same_app, 0]],
                        [Gdk::DragAction::COPY.to_i,
                         Gdk::DragAction::MOVE.to_i])

        ta = self
        dragged = nil

        b.signal_connect("drag-data-received") do |widget, context, x, y, selection_data, info, time|
          dragged = selection_data.text
        end

        b.signal_connect("drag-drop") do |widget, context, x, y, time|
          ta.designer.toggle_area = self
          ta.designer.component_list.change_to(dragged)
        end

        b
      end
  end

  def show
    btn.show

    if @toggled
      rm.show
    else
      add.show
    end
  end

  def initialize(designer)
    @designer = designer
    @toggled = false
  end
end
