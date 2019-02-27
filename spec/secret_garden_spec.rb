require 'spec_helper'

require 'secret_garden'
require 'secret_garden/backend'

module SecretGarden
  class Dummy < Backend; end
end

describe SecretGarden do

  describe '.add_backend' do
    let(:backend) { :dummy }

    subject { described_class.add_backend backend }

    it 'adds the requested backend to the lookup order' do
      subject
      expect(described_class.backends.first).to be_a described_class::Env
      expect(described_class.backends.last).to be_a described_class::Dummy
    end

  end

  describe '.fetch' do
    before { allow(described_class).to receive(:backends).and_return backends }

    subject { described_class.fetch 'HAYSTACK' }

    context 'multiple backends' do
      let(:backends) { [backend1, backend2] }

      context 'no backend has value' do
        let(:backend1) { double fetch: nil }
        let(:backend2) { backend1 }

        it { is_expected.to be_nil }
      end

      context 'first backend has value' do
        let(:backend1) { double fetch: 'needle' }
        let(:backend2) { double fetch: nil }

        it { is_expected.to eq 'needle' }
      end

      context 'last backend has value' do
        let(:backend1) { double fetch: nil }
        let(:backend2) { double fetch: 'needle' }

        it { is_expected.to eq 'needle' }
      end

    end

  end

  describe '.fetch!' do
    subject { described_class.fetch! 'something' }

    context 'secret was found somewhere' do
      before { allow(described_class).to receive(:fetch).and_return 'ok' }

      it { is_expected.to eq 'ok' }
    end
 
    context 'secret not found' do
      before { allow(described_class).to receive(:fetch).and_return nil }

      it 'raises an error' do
        expect { subject }.to raise_error SecretGarden::SecretNotDefined
      end
    end

  end

  describe '.expose' do

    it 'sets the desired env var' do
      allow(described_class).to receive(:fetch!).and_return 'the secret'
      described_class.expose 'MY_SUPER_SECRET'
      expect(ENV['MY_SUPER_SECRET']).to eq 'the secret'
    end

  end

end
