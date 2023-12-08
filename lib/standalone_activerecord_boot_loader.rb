# frozen_string_literal: true

require_relative 'standalone_activerecord_boot_loader/version'
require 'erb'
require 'zeitwerk'
require 'active_record'
require 'active_record/tasks/database_tasks'
require 'active_support/time'

module StandaloneActiverecordBootLoader
  class Error < StandardError; end

  class Instance
    def initialize(app_root, create_database: true, env: 'development', timezone: 'Tokyo')
      @app_root = app_root
      @create_database = create_database
      @env = env
      @timezone = timezone
    end

    def execute
      setup_zeitwerk
      setup_active_record
    end

    private

    def setup_zeitwerk
      loader = ::Zeitwerk::Loader.new
      loader.push_dir(@app_root.join('app/models'))
      loader.setup
    end

    def setup_active_record
      create_database if @create_database
      ::Time.zone = @timezone
      ::ActiveRecord::Base.establish_connection(database_config[@env])
      ::ActiveRecord::Base.time_zone_aware_attributes = true
    end

    def create_database
      tasks = ::ActiveRecord::Tasks::MySQLDatabaseTasks.new(build_database_config)
      begin
        tasks.create
      rescue StandardError => e
        # ActiveRecord 5系
        if defined?(::ActiveRecord::Tasks::DatabaseAlreadyExists)
          return if e.instance_of?(::ActiveRecord::Tasks::DatabaseAlreadyExists)
        end

        # ActiveRecord 6系以降
        if defined?(::ActiveRecord::DatabaseAlreadyExists)
          return if e.instance_of?(::ActiveRecord::DatabaseAlreadyExists)
        end

        raise e
      end
    end

    def database_yml_path
      @app_root.join('config/database.yml')
    end

    def database_config
      @database_config ||= ::YAML::load(::ERB.new(::File.read(database_yml_path)).result)
    end

    def build_database_config
      unless defined?(::ActiveRecord::DatabaseConfigurations::HashConfig)
        return database_config[@env]
      end

      config = ::ActiveRecord::DatabaseConfigurations::HashConfig.new(@env, 'primary', database_config[@env])
      return config if config.respond_to?(:configuration_hash)

      database_config[@env]
    end
  end
end
