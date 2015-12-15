require 'spec_helper'

# rubocop:disable Metrics/LineLength, Style/SymbolProc, Style/Semicolon
describe ProcSource do
  describe 'initialize' do
    it 'should allow a Proc to be an argument' do
      expect { ProcSource.new proc {} }.not_to raise_error
    end

    it 'should allow a block to be passed' do
      expect { ProcSource.new {} }.not_to raise_error
    end

    it 'should throw if argument is not a proc' do
      expect { ProcSource.new Object.new }.to raise_error ArgumentError, 'argument must be a Proc'
    end

    it 'should throw if an argument is provided along with a block' do
      proc = proc {}
      expect { ProcSource.new(proc) {} }.to raise_error ArgumentError, 'cannot pass both an argument and a block'
    end
  end

  shared_examples 'with no proc' do
    its(:source)     { should eq '' }
    its(:raw_source) { should eq '' }
    its(:to_s)       { should eq '' }
    its(:inspect)    { should eq '' }

    it('should be equal to ProcSource.new(nil)') { should eq ProcSource.new nil }
    it('should be equal to ProcSource.new')      { should eq ProcSource.new     }
  end

  describe 'with a nil proc' do
    subject { ProcSource.new nil }
    include_examples 'with no proc'
  end

  describe 'with no proc' do
    subject { ProcSource.new }
    include_examples 'with no proc'
  end

  shared_examples 'string functions' do |method, other|
    context method do
      it "should delegate to 'proc.#{other}'" do
        prc = proc {}
        expect(ProcSource.new(prc).public_send(method)).to eq prc.public_send(other)
      end

      it "should replace 'proc' with 'lambda' for lambdas" do
        prc = -> {}
        expect(ProcSource.new(prc).public_send(method)).to eq prc.public_send(other).sub('proc', 'lambda')
      end

      it 'should raise error for symbol procs' do
        prc = proc(&:to_s)
        expect { ProcSource.new(prc).public_send(method) }.to raise_error Sourcify::CannotHandleCreatedOnTheFlyProcError
      end

      it 'should raise error for multiple procs on the same line' do
        prc = proc { proc {} }
        expect { ProcSource.new(prc).public_send(method) } .to raise_error Sourcify::MultipleMatchingProcsPerLineError
      end

      it 'should raise error for procs returned from eval' do
        prc = eval 'proc {}'
        expect { ProcSource.new(prc).public_send(method) } .to raise_error Sourcify::CannotParseEvalCodeError
      end
    end
  end

  include_examples 'string functions', :source,     :to_source
  include_examples 'string functions', :raw_source, :to_raw_source

  describe 'to_s' do
    it 'should return the source if proc source can be extracted' do
      prc = proc {}
      expect(ProcSource.new(prc).to_s).to eq 'proc { }'
    end

    it 'should return Object.to_s if proc source cannot be extracted' do
      prc = proc(&:to_s)
      expect(ProcSource.new(prc).to_s).to match(/#<ProcSource:.+>/)
    end
  end

  describe 'inspect' do
    it 'should return the source if proc source can be extracted' do
      prc = proc {}
      expect(ProcSource.new(prc).inspect).to eq 'proc { }'
    end

    it 'should return Object.to_s if proc source cannot be extracted' do
      prc = proc(&:to_s)
      expect(ProcSource.new(prc).inspect).to match(/#<ProcSource:.+>/)
    end
  end

  let(:source) do
    ProcSource.new {}
  end

  describe '==' do
    specify 'sames procs should be equal' do
      expect(source).to eq source
    end

    specify 'procs with empty code should be equal' do
      expect(source).to eq ProcSource.new {}
    end

    specify 'procs with different but equivalent code should not be equal' do
      expect(source).to_not eq ProcSource.new { nil }
    end

    specify 'with different parameters should not be equal' do
      source1 = ProcSource.new { |a, b| a.to_s + b.to_s }
      source2 = ProcSource.new { |c, d| c.to_s + d.to_s }

      expect(source1).to_not eq source2
    end

    specify 'should not be equal when one is a lambda and the other is not' do
      expect(source).to_not eq ProcSource.new -> {}
    end

    specify 'should not be equal with a different parameter arity' do
      expect(source).to_not eq ProcSource.new { |a| a.to_s }
    end

    describe 'symbol procs' do
      let(:source) do
        ProcSource.new proc(&:to_s)
      end

      specify 'same symbol procs should be equal' do
        expect(source).to eq source
      end

      specify 'lexically same symbol procs should be equal' do
        expect(source).to eq ProcSource.new proc(&:to_s)
      end

      specify 'lexically different symbol procs should not be equal' do
        expect(source).to_not eq ProcSource.new(&:inspect)
      end
    end

    specify 'procs where multiple sources are declared on the same line should not be equal' do
      proc1 = proc { 1 }; proc2 = proc { 2 }
      source1 = ProcSource.new proc1
      source2 = ProcSource.new proc2

      expect(source1).to_not eq source2
    end

    specify 'procs when declared via evals should not be equal' do
      proc1   = eval 'proc {}'
      proc2   = eval 'proc {}'
      source1 = ProcSource.new proc1
      source2 = ProcSource.new proc2

      expect(source1).to_not eq source2
    end

    specify 'blocks with different bindings should be equal' do
      object1 = Class.new do
        @var = 42

        def meaning
          proc { @var }
        end
      end.new

      object2 = Class.new do
        @var = 41

        def meaning
          proc { @var }
        end
      end.new

      source1 = ProcSource.new object1.meaning
      source2 = ProcSource.new object2.meaning

      expect(source1).to eq source2
    end
  end

  describe 'match' do
    specify 'sames procs should match' do
      expect(source).to match source
    end

    specify 'procs with empty code should match' do
      expect(source).to match ProcSource.new {}
    end

    specify 'procs with different but equivalent code should not match' do
      expect(source).to_not match ProcSource.new { nil }
    end

    specify 'with different parameters should match' do
      source1 = ProcSource.new { |a, b| a.to_s + b.to_s }
      source2 = ProcSource.new { |c, d| c.to_s + d.to_s }

      expect(source1).to match source2
    end

    specify 'should not match when one is a lambda and the other is not' do
      expect(source).to_not match ProcSource.new -> {}
    end

    specify 'should not be equal with a different parameter arity' do
      expect(source).to_not match ProcSource.new { |a| a.to_s }
    end

    describe 'symbol procs' do
      let(:source) do
        ProcSource.new proc(&:to_s)
      end

      specify 'same symbol procs should match' do
        expect(source).to match source
      end

      specify 'lexically same symbol procs should match' do
        expect(source).to match ProcSource.new proc(&:to_s)
      end

      specify 'lexically different symbol procs should not match' do
        expect(source).to_not match ProcSource.new(&:inspect)
      end
    end

    specify 'procs where multiple sources are declared on the same line should not match' do
      proc1   = proc { 1 }; proc2 = proc { 2 }
      source1 = ProcSource.new proc1
      source2 = ProcSource.new proc2

      expect(source1).to_not match source2
    end

    specify 'procs when declared via evals should not match' do
      proc1   = eval 'proc { }'
      proc2   = eval 'proc { }'
      source1 = ProcSource.new proc1
      source2 = ProcSource.new proc2

      expect(source1).to_not match source2
    end

    specify 'blocks with different bindings should match' do
      object1 = Class.new do
        @var = 42

        def meaning
          proc { @var }
        end
      end.new

      object2 = Class.new do
        @var = 41

        def meaning
          proc { @var }
        end
      end.new

      source1 = ProcSource.new object1.meaning
      source2 = ProcSource.new object2.meaning

      expect(source1).to match source2
    end
  end

  describe 'aliases' do
    specify '=~ should be aliased to match' do
      expect(source.method('=~')).to eq source.method('match')
    end
  end
end
