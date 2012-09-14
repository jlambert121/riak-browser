$: << 'lib'
require 'rubygems'
require 'bundler'

Bundler.require

require 'riakbrowser'

set :environment, :development

Rack::Handler::Thin.run RiakBrowser.new, :Port => 8000
