module ProcExtensions
  module Source
    def self.included(base)
      base.class_eval do
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
