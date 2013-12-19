require 'digest/sha1'
require 'base64'

class Encrypter

    def initialize
        @key = 'a7Jhd9Ope8iJQbpodYN34Yha'
        @hex = 'qHSo70fNuF74dNatIL3u9AAz'
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