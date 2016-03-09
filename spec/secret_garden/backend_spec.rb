require 'spec_helper'

require 'secret_garden/backend'

describe SecretGarden::Backend do
  let(:backend) { described_class.new map }

  describe '#fetch_and_cache' do
    let(:name) { 'BAR' }
    let(:secret) { double :secret }

    subject { backend.fetch_and_cache name }

    context "named secret doesn't exist in the map" do
      let(:map) { double defined?: false, secretfile_path: '/my/pwd/Secretfile' }

      it 'raises an error' do
        expect do
          backend.fetch_and_cache name
        end.to raise_error(SecretGarden::SecretNotDefined)
      end

    end

    context 'named secret exists in map' do
      let(:map) { double defined?: true, :'[]' => secret }

      before { allow(backend).to receive(:fetch).and_return 'golden' }

      it { is_expected.to eq 'golden' }

      it 'stores the given value in the cache' do
        subject
        expect(backend.cache[name]).to eq 'golden'
      end
    end

  end

end

