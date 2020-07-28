# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CodebreakerCpl::Entities::Storage do
  let(:path) { 'database/data_test.yml' }

  before do
    File.new(path, 'w+')
    stub_const('CodebreakerCpl::Entities::Storage::FILE_DATABASE', 'database/data_test.yml')
  end

  after { File.delete(path) }

  let(:test_object) do
    {
      name: 'Vitalii',
      difficulty: CodebreakerCpl::Entities::Game::DIFFICULTIES.keys.first,
      all_attempts: 15,
      attempts_used: 15,
      all_hints: 2,
      hints_used: 0
    }
  end

  context '#storage_exist?' do
    it 'checks existence of file' do
      expect(File).to exist(CodebreakerCpl::Entities::Storage::FILE_DATABASE)
      expect(subject.storage_exist?).to eq true
    end
  end

  context '#save_game_result' do
    it 'saves result' do
      subject.create
      expect(subject).to receive(:save).with(subject.load.push(test_object))
      subject.save_game_result(test_object)
    end
  end
end
