class Req < ActiveRecord::Base
  
  def self.post(url, data, header)
    begin
      RestClient.post( url, data, header)
    rescue => e
      puts e.message
      logger.info "Error: POST #{url}\n#{data}\n#{header}"
      return false
    end
  end
  
  def self.get(url)
    begin
      RestClient.get url
    rescue => e
      puts e.message
      logger.info "Error: GET #{url}"
      return false
    end
  end
  
end
