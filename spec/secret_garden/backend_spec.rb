require 'spec_helper'

require 'secret_garden/backend'

describe SecretGarden::Backend do
  let(:backend) { described_class.new map }

  describe '#fetch' do
    let(:name) { 'BAR' }
    let(:secret) { double :secret }

    subject { backend.fetch name }

    context "named secret doesn't exist in the map" do
      let(:map) { double defined?: false, secretfile_path: '/my/pwd/Secretfile' }

      it 'raises an error' do
        expect do
          backend.fetch name
        end.to raise_error(SecretGarden::SecretNotDefined)
      end

    end

    context 'named secret exists in map' do
      let(:map) { double defined?: true, :'[]' => secret }

      before { allow(backend).to receive(:fetch).and_return 'golden' }

      it { is_expected.to eq 'golden' }
    end

  end

end

