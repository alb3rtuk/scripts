require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'


# PASSWORD ENCRYPTER
encrypter = Encrypter.new
passwords = Array['alb3rtuk', '796432704', 'lkqhacyp52', 'tkmdgqps52', '415741', 'rann7899', 'TKMDGQPS', '2910830622']
passwords.each { | password |
    puts "'#{password} = #{encrypter.encrypt(password)}' done!"
    #x = encrypter.encrypt(password)
    #
    #puts "'#{password} = #{encrypter.decrypt(x)}' done"

}


