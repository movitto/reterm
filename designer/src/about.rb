require 'reterm/version'

class About
  def initialize
    Gtk::AboutDialog.set_email_hook {|about, link|
      p "mo@morsi.org"
      p link
    }
    Gtk::AboutDialog.set_url_hook {|about, link|
      p "http://github.com/movitto/reterm"
      p link
    }

    a = Gtk::AboutDialog.new
    #a.artists   = ["Artist 1 <no1@foo.bar.com>"]
    a.authors = ["Mo Morsi <mo@morsi.org>"]
    a.comments  = "RETerm Terminal UI Designer"
    a.copyright = "Copyright (C) 2017 Mo Morsi"
    #a.documenters = ["Documenter 1 <no1@foo.bar.com>"]
    a.license   = "MIT License"

    icon_theme = Gtk::IconTheme.default
    a.logo = icon_theme.load_icon(icon_theme.icons.first, 48, 0)

    a.program_name = "RETerm Designer"
    #a.translator_credits = "Translator 1\nTranslator 2\n"
    a.version   = RETerm::VERSION
    a.website   = "http://github.com/movitto/reterm"
    a.website_label = "RETerm Project Website"

    a.run
    a.destroy
  end
end # class About

