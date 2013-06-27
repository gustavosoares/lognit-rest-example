module Lognit
  
  class Client
  
    attr_accessor :url, :login, :password, :client, :response, :args
  
    def initialize(url, login, password)
      @url = url
      @login = login
      @password = password
      @args = { :content_type => :json, :accept => :json, }
      @client = nil
      @response = nil
      @cookies = {}
    end
  
    def login
      #RestClient.log.debug("---> Login")
      #pp("---> Login")
      @client = RestClient::Resource.new(@url, @login, @password)
      @response = @client['/login'].get
    
      print_response()

      jsession_id = response.cookies["JSESSIONID"]
      @cookies = { :JSESSIONID => jsession_id }
      @args[:cookies] = { :JSESSIONID => jsession_id }
    end
  
    def print_response
      unless @response.nil?
        # pp @response.code
        # pp @response.headers
        # pp @response.cookies
      else
        pp "No response found"
      end
    end
    
    #generic get
    def get
      @response = @client["#{@url}"].get @args
      print_response()
      json_response = JSON.parse(response)
    end
    
    def post(data)
      @response = @client["#{@url}"].post data.to_json, @args
      print_response()
      return @response
    end
    
    def put(data)
      @response = @client["#{@url}"].put data.to_json, @args
      print_response()
      return @response
    end
    
    def delete(delete_url)
      @response = @client["#{delete_url}"].delete @args
      print_response()
      return @response
    end
    
    def list_groups
      @response = @client["#{@url}"].get @args
      print_response()
      log_groups = JSON.parse(response)
      log_groups["data"]
    end
  
    def create_group(data)
      @response = @client["#{@url}"].post data.to_json, @args
      print_response()
    end
  
    def delete_group(id)
      self.delete("#{@url}/" + id)
    end
  
    def get_data(id, filtro={"key"=>"host", "value"=>"192.0.0.1"}, metadata={"key"=>"group","value"=>"rest_client"})
      data = {"name"=>"teste_rest_client#{id}",
              "spaces" => [],
              "simulationBtnText" => "Simular busca por este grupo",
              "metadata" =>[metadata],
              "templates" =>[],
              "patterns" =>[],
              "filters" => [{"expressions"=> [filtro]}]
              }
    end
  
  end
end