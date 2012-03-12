require File.expand_path('../boot', __FILE__)

#require 'pry'
require 'active_record'
require 'terminal-table'

module Reminder
  ENVIRONMENTS = [ 'development', 'production' ]
  LOCALE = :en # :en, :cs

  extend self

  def environment(app_env)
    app_env = ENVIRONMENTS.first if app_env.blank?
    environment = ENVIRONMENTS.find { |environment| app_env == environment }
    raise %(Invalid environment "#{ app_env }"!) unless environment
    environment
  end

  def initialize!
    establish_connection

    %w( app/controllers/*.rb app/models/*.rb ).each do |part|
      Dir[ Root.join(part) ].each { |file| require file }
    end

    I18n.locale = LOCALE
    I18n.load_path += Dir[ Root.join('config', 'locales', '**', '*.{rb,yml}') ]
  end

  def establish_connection
    config = YAML.load_file( Root.join('config', 'database.yml') )
    ActiveRecord::Base.establish_connection config[Env]
  end
end