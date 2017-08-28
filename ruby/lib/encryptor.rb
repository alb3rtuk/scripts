require 'base64'

class Encryptor

    def initialize

        @key = $cryptoKey
        @hex = $cryptoHex

    end

    def encrypt(string)

        c = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
        c.encrypt
        c.key = @key = Digest::SHA1.hexdigest(@hex)
        e     = c.update(string)
        e << c.final
        Base64.encode64(e)

    end

    def decrypt(string)

        string = Base64.decode64(string)
        c      = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
        c.decrypt
        c.key = @key = Digest::SHA1.hexdigest(@hex)
        d     = c.update(string)
        d << c.final
        d

    end

end