module ProcExtensions
  module Inspect
    def self.install
      Proc.send :include, Methods
    end

    module Methods
      def self.included(base)
        base.class_eval do
          # rubocop:disable Lint/NestedMethodDefinition
          def inspect
            ProcSource.new(self).inspect
          rescue
            super
          end
        end
      end
    end
  end
end
