require "sinatra/activerecord/rake"
require "dotenv/tasks"

namespace :db do
  # require File.join(__dir__, "graphynatra.rb")
end

namespace :tickle do
  task :email do
    require 'uri'
    require 'httparty'
    require 'json'

    class FakeMailgun
      include HTTParty

      base_uri "localhost:7000"
      basic_auth "api", '94DqnQ591M7ae0C8H28i'
    end

    path_to_file = File.join(File.dirname(__FILE__), 'spec/fixtures/proprietaries.csv')
    raise "No file at #{path_to_file}" unless File.exists?(path_to_file)
    file_uri = path_to_file
    # file_uri = "file://#{path_to_file}"
    raise "No file at #{file_uri}" unless File.exists?(file_uri)
    attachment_json = JSON.generate([{ url: file_uri }])
    payload = {
      sender: "sameer.soleja@mailer.molecule.io",
      attachments: attachment_json
    }
    FakeMailgun.post('/webhooks/proprietary', { body: payload })
  end
end

task :tickle => 'tickle:email'

namespace :cleanup do
  namespace :rabbitmq do
    task :setup => :dotenv do
      require 'uri'
      require 'rest_client'
      require 'json'
      require 'pp'

      def uri
        URI(ENV['AMQP_URL'])
      end

      def base_url
        "http://#{uri.user}:#{uri.password}@#{uri.host}:15672"
      end

      def delete_the_queues!(queues_for_cleanup)
        queues_for_cleanup.each do |qn|
          url = "#{base_url}/api/queues/#{qn}"
          puts "DELETE #{url}"
          RestClient.delete url
        end
      end
    end

    task :queues => 'cleanup:rabbitmq:queues:all'

    namespace :queues do
      task :all => [:cottontail, :graphynatra]

      task :cottontail => 'cleanup:rabbitmq:setup' do
        url = "#{base_url}/api/queues"
        puts "GET #{url}"
        full_list = RestClient.get(url){ |resp, req, res| JSON.parse(resp) }
        queues_for_cleanup = full_list.select do |hash|
          hash['name'] =~ %r{((leporine)|(cottontail))}
        end.map do |hash|
          "#{CGI::escape(hash['vhost'])}/#{hash['name']}"
        end
        delete_the_queues!(queues_for_cleanup)
      end

      task :graphynatra => 'cleanup:rabbitmq:setup' do
        queues = ['proprietaries.published', 'proprietaries.loaded', 'settles.file_identified'].map do |qn|
          "#{CGI::escape('/')}/#{qn}"
        end
        delete_the_queues!(queues)
      end
    end
  end
end

namespace :setup do
  namespace :database do
    task :settles => :dotenv do
      Dir.glob(File.join(__dir__, "models/**/*.rb"), &method(:require))

      end_date = Date.yesterday - 1.days
      begin_date = Date.new(2003, 11, 20)

      env = ENV['RACK_ENV'] || 'development'
      path_to_database_config = File.join(File.dirname(__FILE__), 'config/database.yml')
      config = YAML.load_file(path_to_database_config)
      connection_parameters = config[env]
      ActiveRecord::Base.establish_connection(connection_parameters)

      ActiveRecord::Base.transaction do
        (begin_date..end_date).each do |d|
          filename = "icecleared_power_#{d.strftime('%Y_%m_%d')}.dat"
          puts "PRELOADING #{filename}"
          Settle.create(filename: filename)
        end
      end
    end
  end
end
