require 'bundler'

Bundler.require

# require additional directories here, if needed, just add to the %w() expression
# %w(models lib handlers).each{ |d| Dir.glob(File.join(__dir__, "#{d}/**/*.rb"), &method(:require)) }

Dotenv.load

class Webstub < Sinatra::Base
  configure do
    register Sinatra::Reloader
    enable :logging

    # to do a simple authentication protected area
    # use Rack::Auth::Basic, "Protected Area" do |username, password|
    # end
  end

  get '/' do
    { status: 'OK' }.to_json
  end

  get '/foos' do
    [{ foo: { id: 1, name: "bill" } }].to_json
  end

  get '/foos/:id' do
    { foo: { id: 1, name: "bill" } }.to_json
  end

  post '/foos' do
    { foo: { id: 2, name: "ted" } }.to_json # this is the object just created by the POST
  end

  get '/reps' do
    {Reps:[{lastName: "Doe", firstName: "John", userId: 34},{ lastName: "Kennedy", firstName: "Jacob", userId: 86},{lastName: "Smith", firstName: "Jane", userId: 73}]}.to_json
  end

  run! if app_file = $0
end

