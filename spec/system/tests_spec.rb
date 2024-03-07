require_relative '../../server.rb'
require 'rack/test'

RSpec.describe 'App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /tests' do
    context 'successfully' do
      it 'there are no records' do
        get '/tests'
        
        expect(last_response.status).to eq(200)
        expect(last_response.headers['Content-Type']).to include('application/json')
        records = JSON.parse(last_response.body)
        expect(records).to eq([])
      end

      it 'there are records' do
        fake_return = [
          { id: 1, name: 'John', age: 30 },
          { id: 2, name: 'Jane', age: 25 },
          { id: 3, name: 'Bob', age: 40 },
          { id: 4, name: 'Alice', age: 35 },
          { id: 5, name: 'Charlie', age: 45 }
        ]
        allow(MedicalRecord).to receive(:all).and_return(fake_return)

        get '/tests'
        
        expect(last_response.status).to eq(200)
        expect(last_response.headers['Content-Type']).to include('application/json')
        records = JSON.parse(last_response.body)
        expect(records.count).to eq(5)
      end
    end
  end
end
