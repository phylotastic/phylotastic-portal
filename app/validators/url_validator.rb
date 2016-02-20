class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    begin
      uri = URI.parse(value)
      resp = uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      resp = false
    end
    unless resp == true
      # record.errors[attribute] << (options[:message] || "is not an url")
      record.errors[attribute] << "that you provided is not valid"
    end
  end
end