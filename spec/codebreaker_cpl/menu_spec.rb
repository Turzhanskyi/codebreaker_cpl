# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CodebreakerCpl::Entities::Menu do
  let(:hints_array) { [1, 2] }
  let(:code) { [1, 2, 3, 4] }
  let(:command) { '1111' }
  let(:valid_name) { 'a' * rand(3..20) }
  let(:invalid_name) { 'a' * rand(0..2) }
  let(:list) do
    [{
      name: valid_name,
      difficulty: CodebreakerCpl::Entities::Game::DIFFICULTIES.keys.first.to_s,
      all_attempts: 15,
      attempts_used: 15,
      all_hints: 2,
      hints_used: 0
    }]
  end

  context '#game_menu method' do
    it 'works with choice_options' do
      expect(subject.renderer).to receive(:start_message)
      expect(subject).to receive(:ask)
      expect(subject).to receive(:choice_menu_process).once
      subject.game_menu
    end
  end

  context '#rules' do
    it 'calls rules message' do
      expect(subject.renderer).to receive(:rules)
      expect(subject).to receive(:game_menu)
      subject.send(:rules)
    end
  end

  context '#start method' do
    it do
      expect(subject).to receive(:registrate_user)
      expect(subject).to receive(:level_choice)
      expect(subject).to receive(:game_process)
      subject.send(:start)
    end
  end

  context '#save_result method' do
    it 'expexts the choice of user' do
      expect(subject).to receive(:ask)
        .with(:save_results_message) { CodebreakerCpl::Entities::Menu::CHOOSE_COMMANDS[:yes] }
      subject.instance_variable_set(:@name, valid_name)
      expect(subject.game).to receive(:to_h).with(valid_name) { {} }
      expect(subject.storage).to receive(:save_game_result).with({})
      subject.send(:save_result)
    end
  end

  context '#registration method' do
    it 'set name' do
      expect(subject).to receive(:ask).with(:registration).and_return(valid_name)
      subject.send(:registrate_user)
    end
  end

  context '#name_valid? method' do
    it 'returns true' do
      expect(subject.send(:name_valid?, valid_name)).to be true
    end

    it 'returns false' do
      expect(subject.send(:name_valid?, invalid_name)).to be false
    end
  end

  context '#level_choice method' do
    let(:difficulties) { CodebreakerCpl::Entities::Game::DIFFICULTIES.keys.join(' | ') }
    it 'returns #generate_game' do
      level = CodebreakerCpl::Entities::Game::DIFFICULTIES.keys.first
      expect(subject).to receive(:ask).with(:hard_level, levels: difficulties) { level }
      expect(subject).to receive(:generate_game).with(CodebreakerCpl::Entities::Game::DIFFICULTIES[level.to_sym])
      subject.send(:level_choice)
    end

    it 'returns #game_menu' do
      exit = CodebreakerCpl::Entities::Menu::COMMANDS[:exit]
      expect(subject).to receive(:ask).with(:hard_level, levels: difficulties) { exit }
      expect(subject).to receive(:game_menu)
      subject.send(:level_choice)
    end

    it 'returns #command_error' do
      expect(subject).to receive(:ask).with(:hard_level, levels: difficulties) { command }
      expect(subject.renderer).to receive(:command_error)
      allow(subject).to receive(:loop).and_yield
      subject.send(:level_choice)
    end
  end

  context '#choice_code_process method' do
    it 'returns #take_a_hint!' do
      subject.instance_variable_set(:@guess, CodebreakerCpl::Entities::Menu::HINT_COMMAND)
      expect(subject).to receive(:hint_process)
      subject.send(:choice_code_process)
    end

    it 'returns #game_menu' do
      subject.instance_variable_set(:@guess, CodebreakerCpl::Entities::Menu::COMMANDS[:exit])
      expect(subject).to receive(:game_menu)
      subject.send(:choice_code_process)
    end

    it 'returns #handle_command' do
      subject.instance_variable_set(:@guess, command)
      expect(subject).to receive(:handle_command)
      subject.send(:choice_code_process)
    end
  end

  context '#render_stats' do
    it 'returns list' do
      expect(list).to receive(:each_with_index)
      subject.send(:render_stats, list)
    end
  end

  context '#choice_menu_process' do
    %i[rules stats start].each do |command|
      it "returns ##{command}" do
        expect(subject).to receive(command)
        subject.send(:choice_menu_process, CodebreakerCpl::Entities::Menu::COMMANDS[command])
      end
    end

    it 'returns #exit_from_game' do
      expect(subject).to receive(:exit_from_game)
      subject.send(:choice_menu_process, CodebreakerCpl::Entities::Menu::COMMANDS[:exit])
    end

    it 'returns #command_error' do
      expect(subject.renderer).to receive(:command_error)
      expect(subject).to receive(:game_menu)
      subject.send(:choice_menu_process, command)
    end
  end

  context '#exit_from_game method' do
    it 'returns message' do
      expect(subject.renderer).to receive(:goodbye_message)
      expect(subject).to receive(:exit)
      subject.send(:exit_from_game)
    end
  end

  context '#generate_game method' do
    it do
      difficulty = CodebreakerCpl::Entities::Game::DIFFICULTIES[:easy]
      expect(subject.game).to receive(:generate).with(difficulty)
      expect(subject.renderer).to receive(:message).with(:difficulty,
                                                         hints: difficulty[:hints],
                                                         attempts: difficulty[:attempts])
      subject.send(:generate_game, difficulty)
    end
  end

  context '#handle_lose method' do
    it do
      expect(subject.renderer).to receive(:lost_game_message).with(subject.game.code)
      expect(subject).to receive(:game_menu)
      subject.send(:handle_lose)
    end
  end

  context '#handle_win method' do
    it do
      expect(subject.renderer).to receive(:win_game_message)
      expect(subject).to receive(:save_result)
      expect(subject).to receive(:game_menu)
      subject.send(:handle_win)
    end
  end

  context '#game_process method' do
    it 'returns #handle_win' do
      subject.game.instance_variable_set(:@attempts, CodebreakerCpl::Entities::Game::DIFFICULTIES[:easy][:attempts])
      expect(subject).to receive(:ask) { command }
      expect(subject.game).to receive(:win?).with(command) { true }
      expect(subject).to receive(:handle_win)
      subject.send(:game_process)
    end
    it 'retuns #handle_lose' do
      subject.game.instance_variable_set(:@attempts, 0)
      expect(subject).to receive(:handle_lose)
      subject.send(:game_process)
    end
  end

  context '#ask method' do
    it 'retuns msg' do
      phrase_key = :rules
      expect(subject.renderer).to receive(:message).with(phrase_key, {})
      allow(subject).to receive(:gets).and_return('')
      subject.send(:ask, phrase_key)
    end
  end
end
