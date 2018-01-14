def build_component(designer, component, params)
  # TODO all graphical components created here
  # should be resizable by dragging widget border
  # (unless fill or expand property is true).
  # Widgets created in Grid layouts should be
  # moveable by dragging component.
  #
  # Resizing or dragging component should update
  # backend component / effect final output params

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

  # elsif component == :Grid
    # TODO need to create a new component based
    # on Gtk Grid Layout and use here in lieu
    # of ToggleArea.

  else
    # TODO visual properties based on component params
    # eg actually render component of width/height at
    # x/y coordinate w/ component-specific params,
    # such as text for labels, options for radios, etc
    return designer.component_list.image_for(component)

  end
end
