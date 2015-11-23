require 'spec_helper'

require 'core_extensions/proc/match'

Proc.include ProcExtensions::Match

describe Proc do
  include_context 'stub_proc_source'

  specify 'match should delegate to ProcSource#==' do
    proc1 = proc {}
    proc2 = proc {}

    source1 = stub_proc_source(proc1)
    source2 = stub_proc_source(proc2)

    result = Object.new
    expect(source1).to receive(:==).with(source2) { result }

    expect(proc1.match proc2).to be result
  end

  specify '=~ should delegate to ProcSource#==' do
    proc1 = proc {}
    proc2 = proc {}

    source1 = stub_proc_source(proc1)
    source2 = stub_proc_source(proc2)

    result = Object.new
    expect(source1).to receive(:==).with(source2) { result }

    expect(proc1 =~ proc2).to be result
  end
end
