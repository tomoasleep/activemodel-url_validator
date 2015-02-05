class UrlValidator < ActiveModel::EachValidator
  class << self
    def valid?(value, options = {})
      options = default_options.merge(options)
      uri = URI.parse(value)
      if uri.scheme.nil?
        !!options[:allow_no_scheme]
      else
        options[:scheme] ? options[:scheme].include?(uri.scheme) : true
      end
    rescue URI::Error
      false
    end

    def default_options
      { scheme: nil, allow_no_scheme: false }
    end
  end

  def validate_each(record, attribute, value)
    unless self.class.valid?(value, options)
      record.errors.add(attribute, options[:message] || :invalid_url)
    end
  end
end
