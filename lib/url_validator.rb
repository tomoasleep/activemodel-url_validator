class UrlValidator < ActiveModel::EachValidator
  class << self
    def valid?(value, options = {})
      options = default_options.merge(options)
      uri = URI.parse(value)

      [:scheme_appearance, :host_appearance, :scheme_type].all? do |method|
        send("validate_#{method}", uri, options)
      end
    rescue URI::Error
      false
    end

    def default_options
      { scheme: nil, allow_no_scheme: false, allow_no_host: false }
    end

    private

    def validate_scheme_appearance(uri, options)
      uri.scheme.nil? ? options[:allow_no_scheme] : true
    end

    def validate_host_appearance(uri, options)
      uri.host.nil? ? options[:allow_no_host] : true
    end

    def validate_scheme_type(uri, options)
      if options[:scheme]
        if uri.scheme.nil? && options[:allow_no_scheme]
          true
        else
          options[:scheme].include?(uri.scheme)
        end
      else
        true
      end
    end
  end

  def validate_each(record, attribute, value)
    unless self.class.valid?(value, options)
      record.errors.add(attribute, options[:message] || :invalid_url)
    end
  end
end
