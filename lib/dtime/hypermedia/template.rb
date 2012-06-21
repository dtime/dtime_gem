require 'dtime/hypermedia/build_object'
module Dtime
  module Hypermedia
    class Template < Hashie::Mash


      def fields
        self.data
      end

      def build_from_template(hash = {})

        defaults = self.fetch('data', {}).inject({}) do |ret, (name, field)|
          ret[name] = field.value
          ret
        end

        Dtime::Hypermedia::BuildObject.new(self, defaults.merge(hash))
      end

      def build(*args)
        build_from_template(*args)
      end

    end
  end
end
