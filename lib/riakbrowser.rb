require 'rubygems'
require 'sinatra'
require 'riak'
require 'multi_json'
require 'time'
require 'uuid'

class RiakBrowser < Sinatra::Base
  
  configure do
    set :views, File.join(File.expand_path(File.dirname(__FILE__)), "../", "views")
    set :public_folder, Proc.new { File.join(root, "../static") }
#    enable :sessions
  end
  
  def connect server
    server_name, port = server.split('_')
    Riak::Client.new(:nodes => [{:host => server_name, :http_port => port}])
  end
  
  before do
    # Ruby 1.8 doesn't maintain hash order, array of hashes
    @breadcrumbs = [{'name' => 'Home', 'link' => '/'}]
  end

  get '/server/:server/bucket/:bucket/key/add' do
    @server = params[:server]
    @bucket = params[:bucket]
    @breadcrumbs << {'name' => "Server: #{@server}", 'link' => "/server/#{@server}"}
    @breadcrumbs << {'name' => "Bucket: #{@bucket}", 'link' => "/server/#{@server}/bucket/#{@bucket}"}
    @breadcrumbs << {'name' => "Add Key", 'link' => "#"}
    @mode = 'Add'
    @uuid_key = UUID.create_random
    erb :mod_key
  end
  
  post '/server/:server/bucket/:bucket/key/add' do
    @server = params[:server]
    @bucket = params[:bucket]
    content_type = params['content_type']
    data = params['json_data']
    @key = params['new_key']
    
    client = connect @server
    to_store = client[@bucket].get_or_new(@key)
    to_store.data = data
    to_store.content_type = content_type
    to_store.store

    redirect "/server/#{@server}/bucket/#{@bucket}/key/#{@key}"
  end

  get '/server/:server/bucket/:bucket/key/:key/copy' do
    @server = params[:server]
    @bucket = params[:bucket]
    @key = params[:key]
    @breadcrumbs << {'name' => "Server: #{@server}", 'link' => "/server/#{@server}"}
    @breadcrumbs << {'name' => "Bucket: #{@bucket}", 'link' => "/server/#{@server}/bucket/#{@bucket}"}
    @breadcrumbs << {'name' => "Copy Key", 'link' => "#"}
    @mode = 'Copy'
    
    client = connect @server
    @uuid_key = UUID.create_random
    @json_data = client[@bucket][@key].data
    erb :mod_key
  end
  
  post '/server/:server/bucket/:bucket/key/:key/copy' do
    @server = params[:server]
    @bucket = params[:bucket]
    content_type = params['content_type']
    data = params['json_data']
    @key = params['new_key']
    
    client = connect @server
    to_store = client[@bucket].get_or_new(@key)
    to_store.data = data
    to_store.content_type = content_type
    to_store.store

    redirect "/server/#{@server}/bucket/#{@bucket}/key/#{@key}"    
  end

  get '/server/:server/bucket/:bucket/key/:key/edit' do
    @server = params[:server]
    @bucket = params[:bucket]
    @key = params[:key]
    @breadcrumbs << {'name' => "Server: #{@server}", 'link' => "/server/#{@server}"}
    @breadcrumbs << {'name' => "Bucket: #{@bucket}", 'link' => "/server/#{@server}/bucket/#{@bucket}"}
    @breadcrumbs << {'name' => "Edit Key", 'link' => "#"}
    @mode = 'Edit'
    
    @uuid_key = @key
    client = connect @server
    @json_data = client[@bucket][@key].data
    @json_data.gsub!(',', ",\n")
    
    erb :mod_key
  end
  
  post '/server/:server/bucket/:bucket/key/:key/edit' do
    @server = params[:server]
    @bucket = params[:bucket]
    @key = params[:key]
    content_type = params['content_type']
    data = params['json_data']
    
    client = connect @server
    to_store = client[@bucket].get_or_new(@key)
    to_store.data = data
    to_store.content_type = content_type
    to_store.store

    redirect "/server/#{@server}/bucket/#{@bucket}/key/#{@key}"    
  end

  get '/server/:server/bucket/:bucket/key/:key/delete' do
    @server = params[:server]
    @bucket = params[:bucket]
    @key = params[:key]
    
    client = connect @server
    client[@bucket][@key].delete

    redirect "/server/#{@server}/bucket/#{@bucket}"
  end
  
  get '/server/:server/bucket/:bucket/key/:key' do
    @server = params[:server]
    @bucket = params[:bucket]
    @key = params[:key]
    @breadcrumbs << {'name' => "Server: #{@server}", 'link' => "/server/#{@server}"}
    @breadcrumbs << {'name' => "Bucket: #{@bucket}", 'link' => "/server/#{@server}/bucket/#{@bucket}"}
    @breadcrumbs << {'name' => "Key: #{@key}", 'link' => "/server/#{@server}/bucket/#{@bucket}/key/#{@key}"}
    #@data = MultiJson.load(@client[@bucket][@key].data)
    client = connect @server
    if !client[@bucket].exist?(@key)
      redirect "/server/#{@server}/bucket/#{@bucket}"
    end
    @data = client[@bucket][@key].data
    erb :view_key
  end

  get '/server/:server/bucket/add' do
    @server = params[:server]
    @breadcrumbs << {'name' => "Server: #{@server}", 'link' => "/server/#{@server}"}
    @breadcrumbs << {'name' => "Bucket: Add Bucket", 'link' => "#"}
    erb :add_bucket
  end

  post '/server/:server/bucket/add' do
    @server = params[:server]
    @bucket = params['new_bucket']
    redirect "/server/#{@server}/bucket/#{@bucket}"
  end
  
  get '/server/:server/bucket/:bucket' do
    @server = params[:server]
    @bucket = params[:bucket]
    @breadcrumbs << {'name' => "Server: #{@server}", 'link' => "/server/#{@server}"}
    @breadcrumbs << {'name' => "Bucket: #{@bucket}", 'link' => "/server/#{@server}/bucket/#{@bucket}"}
    client = connect @server
    raw_keys = client[@bucket].keys
    @keys = raw_keys.sort
    erb :keys
  end

  get '/server/:server' do
    @server = params[:server]
    @breadcrumbs << {'name' => "Server: #{@server}", 'link' => "/server/#{@server}"}
    local_buckets = []
    client = connect @server
    raw_buckets = client.buckets
    
    raw_buckets.each do |raw_bucket|
      local_buckets << raw_bucket.name
    end
    
    @buckets = local_buckets.sort
    erb :buckets
  end
  
  get '/' do
    erb :index
  end
end