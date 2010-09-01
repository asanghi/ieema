# Include hook code here
require 'spreadsheet'
require "spreadsheet_on_rails"

Mime::Type.register "application/vnd.ms-excel", :xls
ActionView::Template.register_template_handler 'rxls', SpreadsheetOnRails::Handler
