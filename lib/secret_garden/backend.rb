require 'secret_garden'

module SecretGarden

  class Backend

    attr_accessor :map, :cache

    def initialize(map, **options)
      self.map = map
      self.cache = {}
      options.each do |key, val|
        send "#{key}=", val
      end
    end

    def fetch_and_cache(name)
      unless map.defined?(name)
        raise SecretGarden::SecretNotDefined,
          "There is no secret #{name.inspect} defined in #{map.secretfile_path}"
      end
      secret = map[name]
      self.cache[name] ||= fetch(secret)
    end

  end

end
