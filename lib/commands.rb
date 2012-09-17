module Lognit
  
  class Command
    
    def self.command_stat(lognit_client)
      lognit_client.url = RESOURCES[:stats]
      puts "uri: #{lognit_client.url}"
      stats = lognit_client.get
      puts stats.inspect
    end
    
    def self.command_importa_usuario(lognit_client)
      puts "--- IMPORT USER ---"
      lognit_client.url = RESOURCES[:user]
      puts "uri: #{lognit_client.url}"
      tokens = OPTIONS[:import_user].split(':')
      puts "tokens: #{tokens.inspect}"
      fullname = nil
      email = nil
      if tokens.size == 2
        fullname = tokens[0]
        email = tokens[1]
      else
        fullname = tokens[0]
        email = tokens[0]
      end
      puts "fullname: #{fullname}"
      puts "email: #{email}"
      response = lognit_client.post({:email => email, :displayName => fullname})
    end
    
    def self.command_export_group(lognit_client)
      group_name = OPTIONS[:export_group]
      puts "--- EXPORTING GROUP #{group_name} ---"
      lognit_client.url = RESOURCES[:group]
      groups_json = lognit_client.get
      groups = groups_json["data"]
      group_ = nil
      groups.each do |data|
        if data["name"] == group_name
          group_ = data
          puts group_.inspect
          puts '------'
          filename = "/tmp/#{group_name}.export"
          File.open(filename, 'w') {|f| f.write(group_.inspect) }
          puts "File #{filename} has been written to disk."
        end
      end
    end
    
    def self.command_importa_time(lognit_client)
      puts "--- IMPORT TEAM ---"
      lognit_client.url = RESOURCES[:team]
      puts "uri: #{lognit_client.url}"
      tokens = OPTIONS[:import_team].split(':')
      puts "tokens: #{tokens.inspect}"
      fullname = nil
      email = nil
      team = nil
      if tokens.size == 2
        email = tokens[0]
        team = tokens[1]
      else
        fullname = tokens[0]
        email = tokens[1]
        team = tokens[2]
      end
      puts "fullname: #{fullname}"
      puts "email: #{email}"
      puts "team: #{team}"
      teams_json = lognit_client.get
      teams = teams_json["data"]
      team_ = nil
      teams.each do |data|
        if data["name"] == team
          team_ = data
          puts team_.inspect
          puts '------'
        end
      end
      # teams_json.each do |k,v|
      #   puts v.inspect
      #   puts '-----'
      # end
    end
    
  end
  
end