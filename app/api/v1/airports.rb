require 'net/http'

module API
  module V1
    class Airports < Grape::API
      resource :airports do
        desc 'Returns airports list'
        params do
          requires :term, type: String
        end
        get do
          url = "http://node.locomote.com/code-task/airports?q=#{params[:term]}"
          response = Net::HTTP.get_response(URI.parse(url))
          airports = JSON.parse(response.body)
          airports.map { |airport| { value: airport['airportCode'], label: "#{airport['airportName']}, #{airport['cityName']} #{airport['countryName']}" } }
        end
      end
    end
  end
end
