require 'sinatra'
require 'sinatra/base'
require 'sinatra/json'
require 'json'

class App < Sinatra::Base
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == ENV['SINATRA_USERNAME'] and password == ENV['SINATRA_PASSWORD']
  end

  post '/bootstrap_chef_client' do
    begin
      data = JSON.parse request.body.read
      blockchain_flavor = data['blockchain_flavor']
      system "cd ~/chef-repo && knife bootstrap #{data['ip_address']} -x root -A -P password --sudo --use-sudo-password -N #{data['name']}  -r 'recipe[bitcoin::#{blockchain_flavor}]'"
      system "cd ~/chef-repo && ssh root@#{data['ip_address']} 'sudo chef-client'"
    rescue Exception => error
      puts "Error: #{error}"
    end
  end
end
