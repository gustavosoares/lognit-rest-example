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
      -c, --create_groups              Create a group
      -s, --stat                       Get usage statistics
      -i, --import-user=val            Create an user. Specify the username and its email separated by ":" 
                                         Ex: teste:teste@corp.globo.com
      -t, --import-team=val            Set a team for a user.
          --export-group=val
                                       Exports a group to disk. Val is the group name to export.
          --import-group=val
                                       Import a group to disk. Val is the exported group or a path with exported files.

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
  
Then, run the following command:  
  
    cat times/busca.txt | while read line; do ruby lognit_rest.rb -l someuser@corp.globo.com -p 123456 -u localhost -i "${line}"; done
    
## Associate a team for a use ##

First you MUST create the users and the team that you wish to associate.

Them, using the same text file used for create users in batch, run the following command:

     cat j1.txt  | cut -d ":" -f 2 | while read line; do ruby lognit_rest.rb -l someuser@corp.globo.com -p 123456 -u localhost -t "${line}":jornalismo; done

## Get Stats ##

    ruby lognit_rest.rb -l someuser@corp.globo.com -p 123456 -u localhost -s  
  
## Export group ##

If the group is found, then a text file will be written to /tmp/[group name].export

    ruby lognit_rest.rb -l gustavosouza@corp.globo.com -p 111111 -u localhost --export-group=abc
  

HOW TO SEND LOG MESSAGES TO LOGNIT
==================================

# Java

Sample configuration for log4j

## properties
    log4j.rootLogger=INFO, SYSLOG
    log4j.appender.SYSLOG=org.apache.log4j.net.SyslogAppender
    log4j.appender.SYSLOG.syslogHost=localhost
    log4j.appender.SYSLOG.layout=org.apache.log4j.PatternLayout
    log4j.appender.SYSLOG.layout.ConversionPattern=MY-APPLICATION [%c] %m%n
    log4j.appender.SYSLOG.Header=true
    log4j.appender.SYSLOG.Facility=LOCAL2


    <appender name="syslog" class="org.apache.log4j.net.SyslogAppender">
        <!--<param name="Threshold" value="INFO"/>-->
        <param name="syslogHost" value="localhost"/>
        <param name="Header" value="true"/>
        <param name="Facility" value="LOCAL2"/>
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="MINHA-APLICACAO [%c] %m%n"/>
        </layout>
    </appender>

_OBS: For log4j versions prior to 1.2.15 is necessary to put the hostname parameter before MY-APPLICATION._


# Python

RTFM: http://docs.python.org/library/logging.handlers.html#sysloghandler

## Example:

    import logging
    from logging.handlers import SysLogHandler

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    syslog = SysLogHandler(address='/dev/log',facility=logging.handlers.SysLogHandler.LOG_LOCAL3)
    formatter = logging.Formatter('APP_NAME: %(name)s %(message)s')
    syslog.setFormatter(formatter)
    logger.addHandler(syslog)


_ATENTTION!!! It is no longer necessary to set the formatter to log the timestamp and the log level. This is already done by syslog. Change APP_NAME by the name of your application. Messages must be logged as string and not as unicode._

## Python - Django

Since version 1.3.x, Django is packed with a new logging api. The documentation is in
https://docs.djangoproject.com/en/dev/topics/logging/

A sample settings.py configuration file is shown below.

    LOGGING = {
        'version': 1,
        'disable_existing_loggers': True,
        'formatters': {
            'verbose': {
                'format': '[%(asctime)s] %(levelname)s [%(module)s] %(message)s'
            },
            'simple': {
                'format': '%(levelname)s %(message)s'
            },
            'syslog': {
                'format': 'APP_NAME: %(name)s %(message)s'
            },
        },
        'handlers': {
            'default': {
                'level':'DEBUG',
                'class':'logging.handlers.RotatingFileHandler',
                'filename': 'logs/app.log',
                'maxBytes': 1024*1024*20, # 20 MB
                'backupCount': 30,
                'formatter':'verbose',
            },
            'syslog': {
                'level':'DEBUG',
                'class':'logging.handlers.SysLogHandler',
                'facility':'logging.handlers.SysLogHandler.LOG_LOCAL3',
                'formatter':'syslog',
            },
            'request_handler': {
                    'level':'DEBUG',
                    'class':'logging.handlers.RotatingFileHandler',
                    'filename': 'logs/django_request.log',
                    'maxBytes': 1024*1024*30, # 30 MB
                    'backupCount': 5,
                    'formatter':'verbose',
            },
            'console':{
                'level':'INFO',
                'class':'logging.StreamHandler',
                'formatter': 'verbose'
            },
            'null': {
                'level':'DEBUG',
                'class':'django.utils.log.NullHandler',
            },
        },
        'loggers': {

            '': {
                'handlers': ['default', 'console'],
                'level': 'DEBUG',
                'propagate': True
            },
            'django.request': { # Stop SQL debug from logging to main logger
                'handlers': ['request_handler'],
                'level': 'DEBUG',
                'propagate': True
            },
            'django.db.backends': {
                 'handlers': ['null'],  # Quiet by default!
                 'propagate': False,
                 'level':'DEBUG',
            },
        }
    }

To use python's logging API you just need to..

    import logging

    logger= logging.getLogger(__name__)
    logger.info("teste 1..2.3..")

## Python - Gunicorn

Please enter the following lines to your configuration file:

    [handler_syslogHandler]
    class=handlers.SysLogHandler
    formatter=syslogFormatter
    args=('/dev/log','local3')

    [formatter_syslogFormatter]
    format=<APP_NAME> [%(name)s] %(message)s


Append to the handler (syslogHandler), formatters(syslogFormatter) and logger_root (syslogHandler) as follow.

    [handlers]
    keys=watchedFileHandler,syslogHandler

    [formatters]
    keys=simpleFormatter,syslogFormatter

    [logger_root]
    level=DEBUG
    handlers=watchedFileHandler,syslogHandler


# Apache

You can customize log format to save some bytes...

    ErrorLog syslog:local6

    LogFormat "%h %l %u \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" lognit_combined


Then, in your virtual host section.

    CustomLog "|/bin/logger -t httpd-<PRODUTO> -p local6.info" lognit_combined


# Ngnix

You will need to apply a patch do nginx, so that it can log to syslog. Reference: https://github.com/yaoweibin/nginx_syslog_patch

Sample configuration file:


    worker_processes  1;

    syslog local6 httpd-<APPLICATION>;

    events {
            worker_connections  1024;
    }

    http {
        include       mime.types;
        default_type  application/octet-stream;

        log_format  main  '$remote_addr - $remote_user [$time_local] $request '
            '"$status" $body_bytes_sent "$http_referer" '
            '"$http_user_agent" "$http_x_forwarded_for"';

        # Include this log_format
        log_format  syslog  '$remote_addr - $remote_user $request '
            '"$status" $body_bytes_sent "$http_referer" '
            '"$http_user_agent" "$http_x_forwarded_for"';

        server {
            listen       80;
            server_name  localhost;

            #send the log to syslog and file.
            access_log  logs/host1.access.log main;
            access_log  syslog:notice syslog;
            error_log syslog:notice|logs/host1.error.log;

            location / {
                root   html;
                index  index.html index.htm;
            }
        }

        server {
            listen       80;
            server_name  www.example.com;

            access_log  logs/host2.access.log main;
            access_log  syslog:notice syslog;
            error_log syslog:warn|logs/host2.error.log;

            location / {
                root   html;
                index  index.html index.htm;
            }
        }

        server {
            listen       80;
            server_name  www.test.com;

            #send the log just to syslog.
            access_log  syslog:error syslog;
            error_log syslog:error;

            location / {
                root   html;
                index  index.html index.htm;
            }
        }
    }

