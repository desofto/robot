# frozen_string_literal: true
module API
  module V1
    class Root < Grape::API
      include API::Exceptions

      helpers do
        def current_user
          # env['warden'].user
        end

        def authorize!(*args)
          # ::Ability::Factory.build_ability_for(current_user).authorize!(*args)
        end
      end

      before do
        # error!({ success: false, error: 'Authentication error' }, 401) unless env['warden'].authenticated?
      end

      version 'v1', using: :path
      format :json

      mount API::V1::Airlines
      mount API::V1::Airports
      mount API::V1::Search
      mount API::V1::Ping
    end
  end
end
