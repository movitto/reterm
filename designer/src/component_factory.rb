def build_component(designer, component, params)
  if component == :Horizontal
    areas = []
    c = Gtk::HBox.new
    cols = params.first
    0.upto(cols-1) {
      area = ToggleArea.new(designer)
      areas << area
      c.add area.btn, :expand => true
    }

    return [c, areas]

  elsif component == :Vertical
    areas = []
    c = Gtk::VBox.new
    rows = params.first
    0.upto(rows-1) {
      area = ToggleArea.new(designer)
      areas << area
      c.add area.btn, :expand => true
    }

    return [c, areas]

  else
    return designer.component_list.image_for(component)

  end
end
