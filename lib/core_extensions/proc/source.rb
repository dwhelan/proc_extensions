module ProcExtensions
  module Source
    def self.install
      Proc.send :include, Methods
    end

    module Methods
      def self.included(base)
        base.class_eval do
          # rubocop:disable Lint/NestedMethodDefinition
          def source
            ProcSource.new(self).source
          end

          def raw_source
            ProcSource.new(self).raw_source
          end
        end
      end
    end
  end
end
