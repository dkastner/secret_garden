require 'vault'

require 'secret_garden/backend'

module SecretGarden

  class Vault < Backend

    class SecretNotDefined < StandardError; end
    class PropertyNotDefined < StandardError; end

    def fetch(secret)
      unless vault_secret = fetch_from_vault(secret.path)
        raise SecretNotDefined,
          "Vault does not have secret at #{secret.path.inspect}"
      end

      unless value = vault_secret.data[secret.property]
        raise PropertyNotDefined,
          "Vault does not have secret at #{secret.path}:#{secret.property}"
      end

      value
    end

    def fetch_from_vault(path)
      Vault.logical.read path
    end

  end

end
