require 'secret_garden'

module SecretGarden

  class Backend

    attr_accessor :map

    def initialize(map)
      self.map = map
    end

    def fetch(name)
      unless map.defined?(name)
        raise SecretGarden::SecretNotDefined,
          "There is no secret #{name.inspect} defined in #{map.secretfile_path}"
      end
      secret = map[name]
      fetch secret
    end

  end

end
