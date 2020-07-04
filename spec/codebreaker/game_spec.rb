# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Codebreaker::Entities::Game do
  let(:lose_result) { '-+++' }
  let(:start_code) { '1111' }
  let(:hints_array) { [1, 2] }
  let(:valid_name) { 'a' * rand(3..20) }
  let(:code) { [1, 1, 1, 1] }

  context '#take_a_hint! method' do
    it 'returnes last el of hints array' do
      subject.instance_variable_set(:@hints, hints_array)
      expected_value = subject.hints.last
      expect(subject.take_a_hint!).to eq expected_value
    end
  end

  context '#generate_secret_code method' do
    it 'checks that number mathes regex template' do
      secret_code = subject.send(:generate_secret_code).join
      expect(secret_code).to match(/^[1-6]{#{Codebreaker::Entities::Game::DIGITS_COUNT}}$/)
    end
  end

  context '#generate method' do
    it do
      difficulty = Codebreaker::Entities::Game::DIFFICULTIES[:easy]
      expect(subject).to receive(:generate_secret_code).and_return(code)
      subject.generate(difficulty)
      expect(subject.attempts).to eq difficulty[:attempts]
      expect(subject.instance_variable_get(:@difficulty)).to eq difficulty
      expect(code).to include(*subject.instance_variable_get(:@hints))
    end
  end

  context '#start_process method' do
    it do
      process = subject.instance_variable_get(:@process)
      win_code = Array.new(Codebreaker::Entities::Game::DIGITS_COUNT,
                           Codebreaker::Entities::Result::MATCHED_DIGIT_CHAR)
      subject.instance_variable_set(:@code, win_code)
      expect(process).to receive(:secret_code_proc).with(win_code.join, start_code)
      subject.start_process(start_code)
    end
  end

  context '#decrease_attempts! method' do
    it 'decreases attempts by one when used' do
      subject.instance_variable_set(:@attempts, 3)
      expect { subject.decrease_attempts! }.to change(subject, :attempts).by(-1)
    end
  end

  context '#to_h method' do
    it 'returns hash' do
      subject.instance_variable_set(:@difficulty, Codebreaker::Entities::Game::DIFFICULTIES[:easy])
      subject.instance_variable_set(:@attempts, 2)
      subject.instance_variable_set(:@hints, hints_array)
      expect(subject.to_h(valid_name)).to be_an_instance_of(Hash)
    end
  end
end
