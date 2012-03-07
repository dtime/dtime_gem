require 'delegate'
module Dtime
  module Hypermedia
    class BuildObject < Hashie::Mash

      attr_reader :_template

      def self.new(template, *args)
        if args.first.is_a? BuildObject
          return args.first
        else
          super
        end
      end

      def initialize(template, *args)
        super(*args)
        @_template = template
      end

      def validate!
        @_template.fields.each do |f|
          validate_field(f)
        end
      end
      def validate_field(field)
        if field.required?
          error_for!(field, :required) if self.fetch(field.name, nil).nil?
        else
        end
      end

      def error_for!(field, type = nil)
        case type
        when :required
          raise TemplateMismatch.new("Field #{field.name} is required")
        else
          raise TemplateMismatch.new("Something wrong with #{field.name}")
        end
      end
    end
  end
end
