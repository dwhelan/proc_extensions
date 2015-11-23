module ProcExtensions
  module Inspect
    def self.included(base)
      base.class_eval do
        def inspect
          ProcSource.new(self).inspect
        rescue
          super
        end
      end
    end
  end
end
