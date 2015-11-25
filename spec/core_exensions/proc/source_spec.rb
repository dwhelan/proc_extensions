require 'spec_helper'

require 'core_extensions/proc/source'

Proc.send :include, ProcExtensions::Source

describe Proc do
  include_context 'stub_proc_source'

  specify 'source should delegate to ProcSource#source' do
    proc = proc {}

    source = stub_proc_source(proc)
    source_contents = Object.new
    expect(source).to receive(:source) { source_contents }

    expect(proc.source).to be source_contents
  end

  specify 'raw_source should delegate to ProcSource#raw_source' do
    proc = proc {}

    source = stub_proc_source(proc)
    source_contents = Object.new
    expect(source).to receive(:raw_source) { source_contents }

    expect(proc.raw_source).to be source_contents
  end
end
