require 'securerandom'

module CodeGenerator
    url_code = {}
    code_url = {}

    def generate_unique_code 
        code_length = 6
        characters = [
            ('a'..'z'),
            ('A'..'Z'),
            ('0'..'9')
        ].map(&:to_a).flatten
        code = (0...code_length).map { characters[rand(characters.lenght)] }.join
        code 
    end

    def self.url_code
        @url_code
    end

    def self.code_url
        @code_url
    end
end