require 'sinatra'
require 'uri'
require 'net/http'

get '/' do
  content_type :html
  File.open('app/views/index.html')
end

post '/upload' do
  csv_file = params['csv_file']

  if csv_file
    uri = URI('http://localhost:3001/tests')
    req = Net::HTTP::Post.new(uri)
    req.set_form([['csv_file', csv_file[:tempfile]]], 'multipart/form-data')
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    puts res.body if res.is_a?(Net::HTTPSuccess)
  end

  redirect '/'
end
