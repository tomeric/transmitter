require "digest/sha1"
  
class KeyGenerator
  def self.generate(length = 40)
    str = ""
    while str.length <= length
      str << Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s)[0...length]
    end
    
    str[0...length]
  end
end