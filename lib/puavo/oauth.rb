
# Some code borrowed from https://github.com/mdp/gibberish

module Puavo
    module OAuth

      # Token Manager for creating encrypted OAuth tokens
      class TokenManager

        def initialize(key, size=256)
            @key = key
            @size = size
            @cipher = OpenSSL::Cipher::Cipher.new("aes-#{size}-cbc")
          end

          # Returns dn, password, host and base as encrypted base64 string.
          # Use decrypt method to get the data back.
          def encrypt(ruby_data)
            json = ruby_data.to_json
            salt = generate_salt
            setup_cipher(:encrypt, salt)
            e = @cipher.update(json) + @cipher.final
            e = "Salted__#{salt}#{e}" # OpenSSL compatible
            # wtf http://stackoverflow.com/questions/2620975/strange-n-in-base64-encoded-string-in-ruby
            Base64.encode64(e).gsub /\n/, ""
          end

          # Decrypt OAuth token data (base64 string) to [dn, password, host,
          # base] array
          def decrypt(data)
            data = Base64.decode64(data)
            salt = data[8..15]
            data = data[16..-1]
            setup_cipher(:decrypt, salt)
            JSON.parse @cipher.update(data) + @cipher.final
          end

          private

          def generate_salt
            s = ''
            8.times {s << rand(255).chr}
            s
          end

          def setup_cipher(method, salt)
            @cipher.send(method)
            @cipher.pkcs5_keyivgen(@key, salt, 1)
          end

      end
    end
end
