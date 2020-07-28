# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CodebreakerCpl::Entities::Statistics do
  context '#stats method' do
    let(:player_1) do
      {
        name: '', difficulty: CodebreakerCpl::Entities::Game::DIFFICULTIES.keys.first,
        all_attempts: 15, attempts_used: 10, all_hints: 2, hints_used: 0
      }
    end
    let(:player_2) do
      {
        name: '', difficulty: CodebreakerCpl::Entities::Game::DIFFICULTIES.keys.first,
        all_attempts: 15, attempts_used: 15, all_hints: 2, hints_used: 1
      }
    end
    let(:player_3) do
      {
        name: '', difficulty: CodebreakerCpl::Entities::Game::DIFFICULTIES.keys.first,
        all_attempts: 15, attempts_used: 5, all_hints: 2, hints_used: 0
      }
    end

    let(:player_4) do
      {
        name: '', difficulty: CodebreakerCpl::Entities::Game::DIFFICULTIES.keys.last,
        all_attempts: 5, attempts_used: 3, all_hints: 1, hints_used: 0
      }
    end

    it 'returns stats' do
      list = [player_1, player_2, player_3, player_4]
      expected_value = [player_4, player_2, player_1, player_3]
      expect(subject.stats(list)).to eq expected_value
    end
  end
end
