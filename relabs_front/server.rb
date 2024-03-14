require 'sinatra'
require 'uri'
require 'net/http'

get '/' do
  content_type :html
  File.open('app/views/index.html')
end
