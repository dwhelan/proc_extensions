require 'spec_helper'

require 'core_extensions/proc/inspect'

Proc.include ProcExtensions::Inspect

describe Proc do
  include_context 'stub_proc_source'

  it 'should delegate inspect to ProcSource#inspect' do
    proc = proc {}

    source = stub_proc_source(proc)
    source_contents = Object.new
    expect(source).to receive(:inspect) { source_contents }

    expect(proc.inspect).to be source_contents
  end

  it 'should call super.inspect if ProcSource#inspect fails' do
    proc = proc {}

    source = stub_proc_source(proc)
    expect(source).to receive(:inspect).and_raise

    expect(proc.inspect).to match /^#<Proc.+>/
  end
end
