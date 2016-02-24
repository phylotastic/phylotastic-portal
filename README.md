# phylotastic-portal

This is the main repository for developing a generalized web UI for phylotastic services.  

Some design documents, including a workflow, are in the design folder, and there is also a [dynamic mockup](http://lumzy.com/access/?id=FC2B5EEE16DB5F9E5192490824153E60). 

## Installation 

1. install Ruby
2. install Rails
3. install redis and sidekiq
4. run "bundle install" at the top level of this repository to install any needed ruby gems. 
5. cp config/database.yml.example database.yml
6. 

To run, execute the following commands in separate terminals: 
* rails server 
* redis-server
* bundle exec sidekiq

