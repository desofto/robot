require 'net/http'

module API
  module V1
    class Search < Grape::API
      resource :search do
        desc 'Returns available flights for selected airline'
        params do
          requires :airline, type: String
          requires :from, type: String
          requires :to, type: String
          requires :date, type: String
        end
        get do
          url = "http://node.locomote.com/code-task/flight_search/#{params['airline']}?date=#{params['date']}&from=#{params['from']}&to=#{params['to']}"
          response = Net::HTTP.get_response(URI.parse(url))
          JSON.parse(response.body)
        end
      end
    end
  end
end
