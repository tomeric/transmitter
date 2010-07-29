class UrlValidator < ActiveModel::EachValidator
  VALID_SCHEMES = ['http', 'https']

  def validate_each(record, attribute, value)
    begin
      uri = Addressable::URI.parse(value)
    
      if VALID_SCHEMES.include?(uri.scheme) && uri.host
        return
      else
        record.errors[attribute] << (options[:message] || "is not a valid URL")
      end
    
    rescue
      record.errors[attribute] << (options[:message] || "is not a valid URL")
    end
  end
end
