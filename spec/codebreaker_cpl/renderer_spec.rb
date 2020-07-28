# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CodebreakerCpl::Entities::Renderer do
  let(:code) { '1111' }

  context '#message method' do
    it 'return puts I18n' do
      msg = :start_message
      expect(I18n).to receive(:t).with(msg, {})
      subject.message(msg)
    end
  end

  context '#start_message method' do
    it 'return start_message' do
      expect(subject).to receive(:message).with(:start_message)
      subject.start_message
    end
  end

  context '#rules method' do
    it 'return rules' do
      expect(subject).to receive(:message).with(:rules)
      subject.rules
    end
  end

  context '#goodbye_message method' do
    it 'return goodbye_message' do
      expect(subject).to receive(:message).with(:goodbye_message)
      subject.goodbye_message
    end
  end

  context '#save_results_message method' do
    it 'return save_results_message' do
      expect(subject).to receive(:message).with(:save_results_message)
      subject.save_results_message
    end
  end

  context '#win_game_message method' do
    it 'return win_game_message' do
      expect(subject).to receive(:message).with(:win_game_message)
      subject.win_game_message
    end
  end

  context '#round_message method' do
    it 'return promt_to_enter_secret_code_hint_exit' do
      expect(subject).to receive(:message).with(:round_message)
      subject.round_message
    end
  end

  context '#lost_game_message method' do
    it 'return lost_game_message' do
      expect(subject).to receive(:message).with(:lost_game_message, code: code)
      subject.lost_game_message(code)
    end
  end

  context '#no_hints_message? method' do
    it 'return no_hints_message?' do
      expect(subject).to receive(:message).with(:have_no_hints_message)
      subject.no_hints_message?
    end
  end

  context '#print_hint_number method' do
    it 'return print_hint_number' do
      expect(subject).to receive(:message).with(:print_hint_number, code: code)
      subject.print_hint_number(code)
    end
  end

  context '#registration_name_emptyness_error method' do
    it 'return registration_name_emptyness_error' do
      expect(subject).to receive(:message).with(:registration_name_emptyness_error)
      subject.registration_name_emptyness_error
    end
  end

  context '#registration_name_length_error method' do
    it 'return registration_name_length_error' do
      expect(subject).to receive(:message).with(:registration_name_length_error)
      subject.registration_name_length_error
    end
  end

  context '#command_error method' do
    it 'return command_error' do
      expect(subject).to receive(:message).with(:command_error)
      subject.command_error
    end
  end

  context '#command_length_error method' do
    it 'return command_length_error' do
      expect(subject).to receive(:message).with(:command_length_error)
      subject.command_length_error
    end
  end

  context '#command_int_error method' do
    it 'return command_int_error' do
      expect(subject).to receive(:message).with(:command_int_error)
      subject.command_int_error
    end
  end
end
