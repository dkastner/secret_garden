require 'spec_helper'

require 'secret_garden/vault'

describe SecretGarden::Vault do
  let(:map) { double entries: [] }
  let(:vault) { described_class.new map }

  describe '#fetch' do
    let(:vault) { described_class.new double }
    let(:secret) { double path: 'mathematician/greek', property: 'archimedes' }

    subject { vault.fetch secret }

    context 'vault has our secret with the given property' do
      let(:vault_secret) { double data: { archimedes: 'eureka!' } }
      before { allow(vault).to receive(:fetch_from_vault).and_return vault_secret }

      it { is_expected.to eq 'eureka!' }
    end

    context "vault has our secret but the property doesn't exist" do
      let(:vault_secret) { double data: { 'hidden' => 'stuff' } }
      before { allow(vault).to receive(:fetch_from_vault).and_return vault_secret }

      it 'raises an error' do
        expect { subject }.to raise_error(described_class::PropertyNotDefined)
      end
    end

    context "vault doesn't have our secret" do
      before { allow(vault).to receive(:fetch_from_vault).and_return nil }

      it 'raises an error' do
        expect { subject }.to raise_error(described_class::SecretNotDefined)
      end
    end

  end

  describe '#fetch_from_vault' do
    before { allow(::Vault).to receive(:logical).and_return(double(read: nil)) }

    subject { vault.fetch_from_vault 'foo' }

    context 'no retries specified' do
      it 'reads without retries' do
        expect(::Vault).to_not receive(:with_retries)
        subject
      end
    end

    context 'with retries specified' do
      let(:vault) { described_class.new map, with_retries: [StandardError, attempts: 3] }

      it 'tells vault to retry requests' do
        expect(::Vault).to receive(:with_retries)
        subject
      end
    end

  end

end

