require 'spec_helper'

require 'fileutils'
require 'tmpdir'

require 'secret_garden/map'

describe SecretGarden::Map do
  let(:pwd) { Dir.mktmpdir }
  let(:map) { described_class.new root: pwd }

  before do
    allow(ENV).to receive(:fetch).with('VAULT_ENV') do
      'myenv'
    end
  end

  after { FileUtils.remove_entry pwd }

  describe '#entries' do

    it 'loads entries from <root>/Secretfile' do
      File.open File.join(pwd, 'Secretfile'), 'w' do |f|
        f.puts <<-SECRETS
# This is my Secretfile
FOO      path/to/foo
BAR_COOL path/to/bar:rab
BAZ      overwrite
BAZ      path/to/$VAULT_ENV/baz:zab
        SECRETS
      end

      expect(map.entries['FOO']).to be_a(SecretGarden::Secret)
      expect(map.entries['BAR_COOL']).to be_a(SecretGarden::Secret)
      expect(map.entries['BAZ']).to be_a(SecretGarden::Secret)
    end

  end

  describe '#parse_secret' do
    before do
      allow(ENV).to receive(:fetch).with('VAULT_ENV') do
        'awesome'
      end
    end

    subject { map.parse_secret line }

    context 'secret is bare' do
      let(:line) { 'SECRET    path/to/me' }

      it { is_expected.to eq ['SECRET', 'path/to/me', nil] }
    end

    context 'secret has a property in its path' do
      let(:line) { 'SECRET    path/to/me:item' }

      it { is_expected.to eq ['SECRET', 'path/to/me', 'item'] }
    end

    context 'secret has an environment variable in its path' do
      let(:line) { 'SECRET    path/to/$VAULT_ENV/me:item' }

      it { is_expected.to eq ['SECRET', 'path/to/awesome/me', 'item'] }
    end

    context 'secret has a bracketed environment variable in its path' do
      let(:line) { 'SECRET    path/to/${VAULT_ENV}/me:item' }

      it { is_expected.to eq ['SECRET', 'path/to/awesome/me', 'item'] }
    end

  end

end

