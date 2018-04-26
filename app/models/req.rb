require 'rest-client'

class Req < ActiveRecord::Base
  
  def self.post(url, data, header)
    begin
      RestClient.post( url, data, header)
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
      logger.info "Error: POST #{url}\n#{data}\n#{header}"
      logger.info e.backtrace
      return {}
    end
  end
  
  def self.get(url)
    begin
      resp = RestClient.get url
      return JSON.parse(resp)
    rescue RestClient::Unauthorized, RestClient::Forbidden => err
      puts Time.current.to_s + ": Access denied"
      print_in_logger([
        err.response.code.to_s + " GET #{url}", 
        "Access denied", 
        err.response
      ])
      return {}
    rescue RestClient::ImATeapot => err
      puts Time.current.to_s + ": The server is a teapot! # RFC 2324"
      print_in_logger([
        err.response.code.to_s + " GET #{url}", 
        "The server is a teapot! # RFC 2324", 
        err.response
      ])
      return {}
    rescue RestClient::ExceptionWithResponse => err
      puts Time.current.to_s + ": The server responsed " + err.response.code.to_s
      print_in_logger([
        err.response.code.to_s + " GET #{url}",
        "The server responsed but something wrong",
        err.response
      ])
      return {}
    rescue JSON::ParserError => err
      puts Time.current.to_s + ": The server responsed " + err.response.code.to_s
      print_in_logger([
        "GET #{url}", 
        "JSON parsing error",
        resp
      ])
      return {}
    rescue
      puts Time.current.to_s
      print_in_logger([
        "GET #{url}", 
        "New exception!!!",
        resp
      ])
      return {}
    end
  end

  def self.print_in_logger(arr)
    arr.each do |mess|
      logger.info Time.current.to_s
      logger.info mess
    end
  end
end
