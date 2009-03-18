# Author  : Mitko Kostov
# Email   : mitkok@7thoughts.com
# Weblog  : http://7thoughts.com/mitko
# License : MIT license

# The default DB has one table named "data" with fields "url"  and "surl".

require 'rubygems'
require 'sinatra'
require 'sequel'
#HOST is your domain
HOST = 'http://localhost:4567/' unless defined? HOST

# Default page, gets the last five records
get '/' do
  haml :index
end

#This function redirect the "shortened" url
get '/:name' do
  if @data = get_record(params[:name])
    redirect @data[:url]
  else
    "URL not found !"
  end
end

#This function saves posted url
post '/' do
  shorten_url
  get_record(1)
  haml :index
end

private 

def link_to (name, url, target="_blank")
  "<a href="+url+" target=\""+target+"\">"+name+"</a>"
end

#This is the function that will shorten and record the posted url
def shorten_url
  db = Sequel.connect('postgres://username:password@localhost:5432/shorty')
  data = db[:data]

  if (data.order(:id).last) 
    data.insert(:url => params[:url], :surl => data.order(:id).last[:surl].succ)
  else
    data.insert(:url => params[:url], :surl => "A")
  end
end

#This fucntion gets record/s from the DB
def get_record(param)
  db = Sequel.connect('postgres://username:password@localhost:5432/shorty')
  if param.is_a?(Integer)
    @data = db[:data].limit(param).order(:id.desc).all
  else
    @data = db[:data].filter(:surl => param).first
  end
end
