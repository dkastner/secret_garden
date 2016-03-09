require "secret_garden/version"

require 'secret_garden/env'
require 'secret_garden/map'

module SecretGarden

  class SecretNotDefined < StandardError; end

  def self.add_backend(val)
    klass = SecretGarden.const_get(val.to_s.capitalize)
    @backends = backends + [klass.new(map)]
    nil
  end

  def self.backends
    @backends ||= [Env.new(map)]
  end

  def self.fetch(name)
    backends.inject(nil) do |value, backend|
      value ||= backend.fetch_and_cache(name)
    end
  end

  def self.fetch!(name)
    value = fetch(name)
    if value.nil?
      raise(SecretNotDefined, "None of your backends have #{name}")
    else
      value
    end
  end

  def self.map
    @map ||= SecretGarden::Map.new root: secret_file_path, env: env
  end

  def self.secret_file_path=(val)
    @secret_file_path = val
  end
  def self.secret_file_path
    @secret_file_path ||= Dir.pwd
  end

  def self.env=(val)
    @env = val
  end
  def self.env
    @env ||= 'development'  # sane default?
  end

end
