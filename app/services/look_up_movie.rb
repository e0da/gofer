require 'json'
require 'net/http'
require 'uri'

module Services

  class LookUpMovie

    API_KEY = ENV['OMDB_API_KEY']
    URI_TEMPLATE = 'http://www.omdbapi.com/?%{params}'.freeze

    private_class_method :new

    def self.call(options)
      new(options).send(:call)
    end

    private

    def initialize(options)
      @title, @year = options.values_at(:title, :year)
    end

    def call
      request_movie
    end

    def request_movie
      response = JSON.parse(Net::HTTP.get(uri))
      case response['Response']
      when 'True'
        puts "#{response['Title']} (#{response['Year']})"
        exit
      when 'False'
        warn "Error: #{response['Error']}"
        exit false
      end
    end

    def params
      parameters = {t: @title, y: @year, apikey: API_KEY}
      URI.encode(parameters.map{|k,v| "#{k}=#{v}"}.join('&'))
    end

    def uri
      URI(URI_TEMPLATE % {params: params})
    end
  end
end
