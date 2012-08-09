README
======

This is a work in progress. :)

INSTALATION
===========

You need to have ruby and rubygems installed on your system. After that, run _gem install bundler_ to get bundler installed. It's strongly recommended to use [RVM](https://rvm.io/).

Run _bundle install_ to install the dependencies in the Gemfile file.

USAGE
======

ruby lognit_rest.rb -h  

Usage: lognit_rest.rb [OPTIONS]  
Abstract description of script  
  
  -l, --login=val                  Lognit login  
  -p, --password=val               Login password  
  -u, --lognit_url                 Lognit url. Default.: localhost  
  -d, --delete_all_groups          Delete all groups  
  -c, --create_all_groups          Create a group  
  -s, --stat                       Get usage statistics  
  -i, --import-user=val            Create an user. Specify the username and its email separated by ":" Ex: teste:teste@corp.globo.com  
  -t, --import-team=val            Set a tem for a user.  
  
  -h, --help                       Show this help message.  

EXAMPLES
========

## Create User ##

You can create users in batch. For this, create a file like the following example:  
  
Luiz Guilherme Pais dos Santos:teste1@a.com  
Gustavo Guimaraes:teste2@a.com  
Gustavo Souza da Luz:teste3@a.com  
Danilo Moura do Nascimento:teste4@a.com  
Rubens Neto:teste4@a.com  
  
Then, run the following code:  
cat times/busca.txt | while read line; do ruby lognit_rest.rb -l someuser@corp.globo.com -p 123456 -u localhost -i "${line}"; done

## Get Stats ##

ruby lognit_rest.rb -l someuser@corp.globo.com -p 123456 -u localhost -s  
  
  