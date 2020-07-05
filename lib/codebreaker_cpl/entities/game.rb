# frozen_string_literal: true

module CodebreakerCpl
  module Entities
    class Game
      DIGITS_COUNT = 4
      DIFFICULTIES = {
        easy: {
          attempts: 15,
          hints: 2
        },
        medium: {
          attempts: 10,
          hints: 1
        },
        hell: {
          attempts: 5,
          hints: 1
        }
      }.freeze
      RANGE = (1..6).freeze

      attr_reader :attempts, :hints, :code

      def initialize
        @process = Result.new
      end

      def generate(difficulty)
        @difficulty = difficulty
        @code = generate_secret_code
        @hints = @code.sample(difficulty[:hints])
        @attempts = difficulty[:attempts]
      end

      def start_process(command)
        @process.secret_code_proc(code.join, command)
      end

      def win?(guess)
        code.join == guess
      end

      def decrease_attempts!
        @attempts -= 1
      end

      def to_h(name)
        {
          name: name,
          difficulty: DIFFICULTIES.key(@difficulty),
          all_attempts: @difficulty[:attempts],
          all_hints: @difficulty[:hints],
          attempts_used: @difficulty[:attempts] - @attempts,
          hints_used: @difficulty[:hints] - @hints.length,
          date: Time.now
        }
      end

      def hints_spent?
        hints.empty?
      end

      def take_a_hint!
        hints.pop
      end

      private

      def generate_secret_code
        Array.new(DIGITS_COUNT) { rand(RANGE) }
      end
    end
  end
end
