require "data_mapper"
require 'sinatra'

env = ENV["RACK_ENV"] || "development"
# we're telling datamapper to use a postgres database on localhost. The name will be "bookmark_manager_test" or "bookmark_manager_development" depending on the environment
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link'
require './lib/tag' # this needs to be done after datamapper is initialis your models, you should finalise them
DataMapper.finalize

# However, the database tables don't exist yet. Let's tell datamapper to create them
DataMapper.auto_upgrade!

get '/' do
  @links = Link.all
  erb :index
end

post '/links' do
  url = params["url"]
  title = params["title"]
  tags = params["tags"].split(" ").map{|tag| Tag.new(:text => tag)}
  Link.create(:url => url, :title => title, :tags => tags)  
  redirect to('/')
end

