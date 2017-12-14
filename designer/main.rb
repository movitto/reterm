#!/usr/bin/ruby

require "vrlib"
require_rel 'src/'

designer = Designer.new
designer.show_glade()

require 'pp'
pp designer.created_list.schema
