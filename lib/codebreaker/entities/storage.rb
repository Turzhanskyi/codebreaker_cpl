# frozen_string_literal: true

module Codebreaker
  module Entities
    class Storage
      FILE_DATABASE = 'database/data.yml'

      def create
        File.new(FILE_DATABASE, 'w')
        File.write(FILE_DATABASE, [].to_yaml)
      end

      def load
        YAML.safe_load(File.open(FILE_DATABASE), [Menu]) if storage_exist?
      end

      def save(object)
        File.open(FILE_DATABASE, 'w') { |file| file.write(YAML.dump(object)) }
      end

      def storage_exist?
        File.exist?(FILE_DATABASE)
      end

      def save_game_result(object)
        create unless storage_exist?
        save(load.push(object))
      end
    end
  end
end
