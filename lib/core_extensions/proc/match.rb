module ProcExtensions
  module Match
    def self.install
      Proc.send :include, Methods
    end

    module Methods
      def self.included(base)
        base.class_eval do
          # rubocop:disable Lint/NestedMethodDefinition
          def match(other)
            ProcSource.new(other) == ProcSource.new(self)
          end

          alias_method :=~, :match
        end
      end
    end
  end
end
