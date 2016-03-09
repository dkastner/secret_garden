module SecretGarden

  class Secret

    attr_accessor :name, :path, :property

    def initialize(name, path, property)
      self.name = name
      self.path = path
      self.property = property
    end

  end

end
