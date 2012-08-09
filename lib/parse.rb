require 'optparse'

# default options
OPTIONS = {
  :login       => nil,
  :password     => nil,
  :lognit_url  => "localhost",
  :delete_all_groups => nil,
  :create_all_groups => nil,
  :stats => nil,
}

# resource uris
RESOURCES = {
  :group => "/rest/log-groups",
  :login => "/rest/users/welcome",
  :user => "/rest/users",
  :team => "/rest/teams",
  :stats => "/rest/stats",
  :index => "",
}

def parse

  optparse = OptionParser.new do |option| 
    script_name = File.basename($0)

    option.set_summary_indent('  ')
    option.banner =    "Usage: #{script_name} [OPTIONS]"
    option.define_head "Abstract description of script"
    option.separator   ""

    option.on("-l", "--login=val", String, :REQUIRED, "Lognit login") do |l|
      OPTIONS[:login] = l
    end
    
    option.on("-p", "--password=val", String, :REQUIRED, "Login password") do |p|
      OPTIONS[:password] = p
    end
    
    option.on("-u", "--lognit_url", String, :REQUIRED, "Lognit url. Default.: localhost") do |u|
      OPTIONS[:lognit_url] = u
    end
    
    option.on("-d", "--delete_all_groups", String, "Delete all groups") do |d|
      OPTIONS[:delete_all_groups] = :delete_all_groups
    end
    
    option.on("-c", "--create_all_groups", String, "Create a group") do |c|
      OPTIONS[:create_all_groups] = :create_all_groups
    end
    
    option.on("-s", "--stat", String, "Get usage statistics") do |s|
      OPTIONS[:stats] = :stats
    end
    
    option.on("-i", "--import-user=val", String, "Create an user. Specify the username and its email separated by \":\" Ex: teste:teste@corp.globo.com") do |user|
      OPTIONS[:import_user] = user
    end
    
    option.on("-t", "--import-team=val", String, "Set a tem for a user.") do |a|
      OPTIONS[:import_team] = a
    end
    
    option.separator ""

    option.on_tail("-h", "--help", "Show this help message.") { puts option; exit }
    
  end
  
  begin                                                                                                                                                                                                             
    optparse.parse!                                                                                                                                                                                                 
    mandatory = [:login, :password, :lognit_url]                      # Enforce the presence of                                                                                                                                                
    missing = mandatory.select{ |param| OPTIONS[param].nil? }        # the -l, -p, -u                                                                                                                    
    if not missing.empty?                                            #                                                                                                                                             
      puts "Missing options: #{missing.join(', ')}"                  #                                                                                                                                             
      puts optparse                                                  #                                                                                                                                             
      exit                                                           #                                                                                                                                             
    end                                                              #                                                                                                                                            
  rescue OptionParser::InvalidOption, OptionParser::MissingArgument      #                                                                                                                                                
    puts $!.to_s                                                           # Friendly output when parsing fails
    puts optparse                                                          # 
    exit                                                                   # 
  end

end