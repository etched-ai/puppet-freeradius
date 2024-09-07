require 'spec_helper'
require 'facter/freeradius'

describe 'freeradius', type: :fact do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      before :each do
        Facter.clear
        orig_facter_value_method = Facter.method(:value)
        allow(Facter).to receive(:value) do |fact|
          if facts.key?(fact)
            facts[fact]
          else
            orig_facter_value_method.call(fact)
          end
        end

        orig_exec_method = Facter::Core::Execution.method(:execute)
        allow(Facter::Core::Execution).to receive(:execute) do |cmd|
          case cmd
          when %r{^(radiusd|freeradius) -v$}
            'FreeRADIUS Version 3.0.21'
          else
            orig_exec_method.call(cmd)
          end
        end
      end

      it 'sets freeradius.version.full' do
        expect(Facter.fact(:freeradius)['version']['full'].value).to eq('3.0.21')
      end

      it 'sets freeradius.version.minor' do
        expect(Facter.fact(:freeradius)['version']['minor'].value).to eq('3.0')
      end

      it 'sets freeradius.version.major' do
        expect(Facter.fact(:freeradius)['version']['major'].value).to eq('3')
      end
    end
  end
end
