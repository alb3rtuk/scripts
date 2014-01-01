require 'digest/sha1'
require 'base64'

class Encrypter

    # I keep all my keys, hex's & passwords stored (and encrypted) locally.
    # These will never be transmitted across the web, git, or anything.. ever!
    # If you made it far enough to read this comment then you, sir, are a sneaky dog.. and I salute you :)
    def initialize
        @key = $cryptoKey
        @hex = $cryptoHex
        return self
    end

    # Encrypts a string. Please note, this is not bomb-proof.
    def encrypt(string)
        c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
        c.encrypt
        c.key = @key = Digest::SHA1.hexdigest(@hex)
        e = c.update(string)
        e << c.final
        return Base64.encode64(e)
    end

    # Decrypts a string.
    def decrypt(string)
        string = Base64.decode64(string)
        c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
        c.decrypt
        c.key = @key = Digest::SHA1.hexdigest(@hex)
        d = c.update(string)
        d << c.final
        return d
    end

end