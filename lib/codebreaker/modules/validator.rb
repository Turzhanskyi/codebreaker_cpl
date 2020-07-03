# frozen_string_literal: true

module Codebreaker
  module Modules
    module Validator
      VALUE_FORMAT = /^[1-6]{4}$/.freeze

      def check_emptyness(value)
        value.empty?
      end

      def check_length(value, min_size, max_size)
        value.size.between?(min_size, max_size)
      end

      def check_command_range(command)
        command =~ VALUE_FORMAT
      end
    end
  end
end
