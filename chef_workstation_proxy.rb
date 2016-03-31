$LOAD_PATH.unshift File.dirname __FILE__
# TODO: Is there a better way to add my lib/ directory to the $LOAD_PATH
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib/big_earth/blockchain"
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib/workers/big_earth/blockchain"
require 'sinatra/base'
require "sinatra/config_file"
require 'sinatra/json'
require 'json'
require 'resque'
module BigEarth
  module Blockchain
    class ChefWorkstationProxy < Sinatra::Base

      register Sinatra::ConfigFile
      config_file './config.yml'
      
      use Rack::Auth::Basic, "Restricted Area" do |username, password|
        username == ENV['CHEF_WORKSTATION_PROXY_USERNAME'] and password == ENV['CHEF_WORKSTATION_PROXY_PASSWORD']
      end
      
      get '/ping.json' do
        require 'node'
        content_type :json
        knife_node = BigEarth::Blockchain::Knife::Node.new
        { status: 'pong' }.to_json
      end
      
      post '/bootstrap_chef_client' do
        require 'bootstrap_chef_client'
        begin
          data = JSON.parse request.body.read
          Resque.enqueue BigEarth::Blockchain::BootstrapChefClient, data
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end

      get '/confirm_chef_client_bootstrapped' do
        begin
          data = JSON.parse request.body.read
          puts "Confirming that Chef Client '#{data['title']}' has been boostrapped"
          if "cd ~/chef-repo && knife node show #{params['title']}"
            # Do Success Things
          else
            # Do Error Things
          end
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
