require 'vault'

require 'secret_garden/backend'

module SecretGarden

  class Vault < Backend

    class SecretNotDefined < StandardError; end
    class PropertyNotDefined < StandardError; end

    # Options for SecretGarden.add_backend
    attr_accessor :with_retries

    def fetch(secret)
      unless vault_secret = fetch_from_vault(secret.path)
        raise SecretNotDefined,
          "Vault does not have secret at #{secret.path.inspect}"
      end

      unless value = vault_secret.data[secret.property.to_sym]
        raise PropertyNotDefined,
          "Vault does not have secret at #{secret.path}:#{secret.property}"
      end

      value
    end

    def fetch_from_vault(path)
      if with_retries
        ::Vault.logical.with_retries(*with_retries) do
          ::Vault.logical.read path
        end
      else
        ::Vault.logical.read path
      end
    end

  end

end
