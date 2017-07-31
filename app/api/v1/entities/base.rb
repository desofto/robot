# frozen_string_literal: true
module API
  module V1
    module Entities
      class Base < Grape::Entity
        format_with(:iso_timestamp, &:iso8601)

        expose :id

        with_options(format_with: :iso_timestamp) do
          expose :created_at, format_with: :iso_timestamp
          expose :updated_at, format_with: :iso_timestamp
        end
      end
    end
  end
end
