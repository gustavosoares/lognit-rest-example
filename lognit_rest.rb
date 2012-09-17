ROOT = File.expand_path(File.join(File.dirname(__FILE__)))
#Acerto o LOAD PATH
$: << ROOT

require 'rubygems'
require 'rest-client'
require 'json'
require 'pp'
require "logger"

require 'lib/parse'
require 'lib/lognit_client'
require 'lib/commands'

#RestClient.log = Logger.new(STDOUT)

parse()

def print_line
  puts "------------------------------------------------"
end

puts "OPTIONS: #{OPTIONS.inspect}"

url = "#{OPTIONS[:lognit_url]}#{RESOURCES[:log_groups]}"

puts "login:     #{OPTIONS[:login]}"
puts "lognit_url:      #{OPTIONS[:lognit_url]}"
puts "url: #{url}"

print_line()


lognit_client = Lognit::Client.new("#{OPTIONS[:lognit_url]}", "#{OPTIONS[:login]}", "#{OPTIONS[:password]}")
lognit_client.login

if OPTIONS[:delete_all_groups]
  lognit_client.url = RESOURCES[:group]
  log_groups = group.list_groups
  pp "------"
  log_groups.each do |log_group|
    pp "#{log_group['name']} -> #{log_group['id']}"
    lognit_client.delete_group(log_group['id'])
  end
end

if OPTIONS[:create_all_groups]
  lognit_client.url = RESOURCES[:group]
  (1..5).each do |n|
     puts "Criando grupo: #{n}"
     lognit_client.create_group(lognit_client.get_data(n))
  end
end

if OPTIONS[:stats]
  Lognit::Command.command_stat(lognit_client)
end

if OPTIONS[:import_user]
  Lognit::Command.command_importa_usuario(lognit_client)
end

if OPTIONS[:import_team]
  Lognit::Command.command_importa_time(lognit_client)
end

if OPTIONS[:export_group]
  Lognit::Command.command_export_group(lognit_client)
end




