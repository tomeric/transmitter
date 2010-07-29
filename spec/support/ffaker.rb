module Faker
  module Internet
    def url
      "#{PROTOCOLS.rand}://#{domain_name}/"
    end
    
    PROTOCOLS = k %w(http https)
  end
end