class FileChooser
  def initialize(window)
    @window = window
  end

  def show
		dialog = Gtk::FileChooserDialog.new(
               :title  => "Save File",
               :parent => @window,
               :action => Gtk::FileChooserAction::SAVE,
               :back   => nil,
               :buttons => [
                 [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL],
                 [Gtk::Stock::OPEN,   Gtk::ResponseType::ACCEPT]
               ])


    file = (dialog.run == Gtk::ResponseType::ACCEPT) ?
            dialog.filename :  nil

		dialog.destroy

    file
  end
end
