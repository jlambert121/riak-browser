$: << File.join(File.dirname(__FILE__), "lib")

require 'riakbrowser'

set :environment, :development

Rack::Handler::Thin.run RiakBrowser.new, :Port => 8000

