# HACK: should not monkey patch RSpec::Matchers::BuiltIn::Match to handle procs
RSpec::Matchers::BuiltIn::Match.class_eval do
  def description
    expected.is_a?(Proc) ? "match #{description_of(expected)}" : super
  end

  def description_of(object)
    object.is_a?(Proc) ? super(ProcSource.new(object).inspect) : super
  end

  base_match = instance_method(:match)

  define_method(:match) do |expected, actual|
    if expected.is_a?(Proc) && actual.is_a?(Proc)
      actual.match(expected)
    else
      base_match.bind(self).call(expected, actual)
    end
  end
end
