# phylotastic-portal

This is the main repository for developing a generalized web UI for phylotastic services.  

Some design documents, including a workflow, are in the design folder, and there is also a [dynamic mockup](http://lumzy.com/access/?id=FC2B5EEE16DB5F9E5192490824153E60). 

## Installation 

##### 1. Install necessary libraries

`sudo apt-get install build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs`

##### 2. Install Ruby

We recommend to install Ruby on Rails using rbenv.  
* OSX: see https://gorails.com/setup/osx/10.10-yosemite
* Ubuntu: see https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04

##### 3. Install Javascript runtime

`sudo add-apt-repository ppa:chris-lea/node.js`

`sudo apt-get update`

`sudo apt-get install nodejs`

`sudo apt-get install redis-server`

##### 4. Install redis and sidekiq

##### 5. Generate SSH (if you don't have one)

`ssh-keygen -t rsa -b 4096 -C "your_email@pikachu.com"`

`eval "$(ssh-agent -s)"`

`ssh-add ~/.ssh/id_rsa`

`cat $HOME/.ssh/id_rsa.pub`

##### 6. Get the phylotastic portal code from github

`git clone https://github.com/phylotastic/phylotastic-portal.git`

##### 7. Install any needed ruby gems. 

* In top level of repository 

`bundle install`
   
##### 8. Config database

* Make a postgres user.  You will be prompted for a password. Write it down. 

`createuser -PSDR portal-app` 

* Make the db

   `createdb -O portal-app phylotastic-portal` 

* Set up the config file that the app will use 
  
  `cp config/database.yml.example config/database.yml`
    
  * Then edit the password to indicate the password written down previously. 

##### 9. Start Solr
  * `rails generate sunspot_rails:install`
  * `bundle exec rake sunspot:solr:start # or sunspot:solr:run to start in foreground`
  
  * `bundle exec rake sunspot:reindex` if needed
  
##### 10. To run, execute the following commands in separate terminals: 
  * `rails server -b 0.0.0.0`
  * `redis-server`
  * `bundle exec sidekiq`

