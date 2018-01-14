# List of supported components
class ComponentsList < VR::ListView
  attr_accessor :designer, :selected

  def initialize(designer)
    @designer = designer

    @cols = {}
    @cols[:pix]   = GdkPixbuf::Pixbuf
    @cols[:title] = String
    @cols[:desc]  = String
    super(@cols)

    parse_signals # XXX needed for row activation callback

    col_title(:pix   => "",
              :title => "Component",
              :desc  => "Description")

    self.visible = true

    first = true
    selection.signal_connect("changed") {
      unless selection.selected.nil?
        _changed(selected_component) unless first
        selection.unselect_all
        first = false
      end
    }

    enable_model_drag_source(Gdk::ModifierType::BUTTON1_MASK,
                             [["reterm", Gtk::TargetFlags::SAME_APP, 0]],
                             Gdk::DragAction::DEFAULT | Gdk::DragAction::COPY)

    lv = self
    signal_connect("drag_data_get") do |widget, context, selection_data, info, time|
      selection_data.set(Gdk::Selection::TYPE_STRING, lv.selected)
    end
  end

  def selected_component
    selection.selected[1]
  end

  def add_component(c)
    row = model.append
    row[id(:pix)]   = icon_for(c)
    row[id(:title)] = c
    row[id(:desc)]  = desc_for(c)
  end

  def self__row_activated(*args)
    _changed(selected_component)
  end

  def change_to(target)
    _changed(target)
  end

  private

  def _changed(selected)
    @selected = selected

    return unless designer.has_toggled_area?

    w = ComponentParams.new(@selected.intern, designer)
    w.show_glade(designer)
  end

  DEFAULT_IMG = GdkPixbuf::Pixbuf.new(:file => "#{IMG_DIR}/blank.png")

  def desc_for(c)
    return "" unless COMPONENTS.key?(c)
    COMPONENTS[c][:desc]
  end

  def icon_for(c)
    if File.exist?("#{IMG_DIR}/#{c.to_s.downcase}.png")
      GdkPixbuf::Pixbuf.new(:file => "#{IMG_DIR}/#{c.to_s.downcase}.png")
    else
      DEFAULT_IMG
    end
  end

  public

  def image_for(c)
    Gtk::Image.new(icon_for(c))
  end
end
