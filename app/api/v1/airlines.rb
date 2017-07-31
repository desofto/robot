require 'net/http'

module API
  module V1
    class Airlines < Grape::API
      resource :airlines do
        desc 'Returns airlines list'
        get do
          url = 'http://node.locomote.com/code-task/airlines'
          response = Net::HTTP.get_response(URI.parse(url))
          JSON.parse(response.body)
        end
      end
    end
  end
end
