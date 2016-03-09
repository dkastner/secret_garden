require 'secret_garden/backend'

module SecretGarden

  class Env < Backend

    def fetch(secret)
      ENV[secret.name]
    end

  end

end
