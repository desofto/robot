# frozen_string_literal: true
module API
  module Exceptions
    def self.included(base)
      base.rescue_from ActiveRecord::RecordNotFound do |_e|
        error!({ message: 'Record not found.' }, 404, 'Content-Type' => 'text/json')
      end

      base.rescue_from ActiveRecord::RecordInvalid do |e|
        error!({ errors: e.record.errors.messages }, 422, 'Content-Type' => 'text/json')
      end

      base.rescue_from ArgumentError do |e|
        error!({ errors: e.message }, 422, 'Content-Type' => 'text/json')
      end
    end
  end
end
