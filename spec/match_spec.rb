require 'spec_helper'

# rubocop:disable Metrics/LineLength
describe 'RSpec::Matchers::BuiltIn::Match extensions' do
  context 'when matching objects other than procs' do
    it 'should use standard match description' do
      expect(match(/a/).description).to eq 'match /a/'
    end

    it 'should use standard match failure message' do
      expect { expect('b').to match(/a/) }.to raise_error(RSpec::Expectations::ExpectationNotMetError, %r{expected .b. to match /a/})
    end

    it 'should use standard match failure message when negated' do
      expect { expect('a').to_not match(/a/) }.to raise_error(RSpec::Expectations::ExpectationNotMetError, %r{expected .a. not to match /a/})
    end

    it 'matching regular expressions should still work' do
      expect('a').to match(/a/)
    end

    it 'not matching regular expressions should still work' do
      expect('b').to_not match(/a/)
    end
  end

  context 'when matching procs' do
    let(:proc1) do
      proc {}
    end

    it 'proc with no args should be "match proc { }"' do
      expect(match(proc {}).description).to eq 'match "proc { }"'
    end

    it 'should use ProcSource#inspect in the description"' do
      expect(match(proc1).description).to eq 'match "proc { }"'
    end

    it 'the same procs should match' do
      expect(proc1).to match proc1
    end

    it 'procs with the same source should match' do
      expect(proc1).to match proc {}
    end

    it 'procs with different sources should not match' do
      expect(proc1).to_not match proc { 42 }
    end

    it 'lambdas should not match procs' do
      expect(proc1).to_not match -> {}
    end

    it 'should show proc source code in failure message' do
      proc2 = proc { 42 }
      expect { expect(proc1).to match proc2 }.to raise_error(RSpec::Expectations::ExpectationNotMetError, 'expected "proc { }" to match "proc { 42 }"')
    end

    it 'should show proc source code in failure message when negated' do
      expect { expect(proc1).to_not match proc1 }.to raise_error(RSpec::Expectations::ExpectationNotMetError, 'expected "proc { }" not to match "proc { }"')
    end
  end
end
