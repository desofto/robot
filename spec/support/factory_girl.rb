# frozen_string_literal: true

module FactoryGirl
  module Strategy
    class FindOrCreate < FactoryGirl::Strategy::Create
      def result(evaluation)
        database_attributes = evaluation.object.attribute_names.map(&:to_sym)
        attribute_aliases   = evaluation.object.attribute_aliases.keys.map(&:to_sym)
        associations        = evaluation.object.class.reflections.keys

        where_attributes = evaluation.hash.dup.slice(*(database_attributes + attribute_aliases + associations))
        instance = evaluation.object.class.where(where_attributes).first

        if instance.present?
          instance
        else
          super
        end
      end
    end
  end
end

FactoryGirl.register_strategy(:find_or_create, FactoryGirl::Strategy::FindOrCreate)
FactoryGirl.allow_class_lookup = false

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
