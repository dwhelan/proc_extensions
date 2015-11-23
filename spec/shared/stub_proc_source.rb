require 'proc_extensions/proc_source'

shared_context 'stub_proc_source' do
  def stub_proc_source(proc)
    double('source').tap do |source|
      expect(ProcSource).to receive(:new).with(proc) { source }
    end
  end
end
