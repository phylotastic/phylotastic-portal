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


============

FOR INSTALLATION IN OS X: 
(Tested in OS X El Capitan 10.11.3)

##### 1. Install Homebrew

##### 2. Install rbenv and redis

   `$ brew update`

   `$ brew install rbenv`

   `$ brew install redis`
   
   `$ rbenv init`

##### 3. Installing Ruby version

   `# list all available versions:`

   `$ rbenv install -l`

   `# install a Ruby version:`
   
   `$ rbenv install 2.3.0`

   `# set global ruby version`
 
   `$ rbenv global 2.3.0`

##### 4.Installing Ruby gems

   `$ gem install bundler`

   `$ gem install rails -v 4.2.6`
   
   `$ rbenv rehash`

##### 5.Check the location where gems are being installed with gem env:

   `$ gem env home`

   `# => ~/.rbenv/versions/<ruby-version>/lib/ruby/gems/…`

##### 6. Get the phylotastic portal code from github
   
   `git clone https://github.com/phylotastic/phylotastic-portal.git`

#####7. Generate SSH (if you don't have one)
   `ssh-keygen -t rsa -b 4096 -C "your_email@pikachu.com"`

   `eval "$(ssh-agent -s)"`

   `ssh-add ~/.ssh/id_rsa`

   `cat $HOME/.ssh/id_rsa.pub`

Add ssh key to your account if you want to contribute

##### 8. Install any needed ruby gems.
In top level of repository
   `bundle install`


##### 9. Install database

   `brew install postgres`
   
   `brew services`

   `gem install pg`

##### 10. Run background database

   `brew services start postgresql`

##### 11 Config database
	•	Make a postgres user. You will be prompted for a password. Write it down.
createuser -PSDR portal-app
	•	Make the db createdb -O portal-app phylotastic-portal 
	•	Set up the config file that the app will use  cp config/database.yml.example config/database.yml
	◦	Then edit the password to indicate the password written down previously.
	◦	
##### 12. Comment 

   `#devise :database_authenticatable, `

   `  #:registerable,`

   `  #       :recoverable, :rememberable, :trackable, :validatable,`

   `  #       :omniauthable, :omniauth_providers => [:google_oauth2]`

in user.rb

Comment 
  
   `# devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }`

in routes.rb

Then run

   `rails generate devise:install`

Then uncomment all of them.

Add 

   `config.omniauth :google_oauth2, APP_CONFIG['google']['id'], APP_CONFIG['google']['secret'], {
    scope: "email"
  }`

in config/initialize/devise.rb

##### 13. Run

   `rake db:migrate`

##### 14. Contact us for config.yml

##### 15. Install JAVA SDK
http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

##### 16. Start Solr
	•	rails generate sunspot_rails:install
	•	bundle exec rake sunspot:solr:start # or sunspot:solr:run to start in foreground
	•	bundle exec rake sunspot:reindex if needed
If you can’t run reindex, delete all /solr folder and stop all solr progresses. Restart again.

If you still get into trouble (likely you are trying to deploy the portal, change path in config/sunspot.yml to /solr/default)

##### 17. To run, execute the following commands in separate terminals:
	•	rails server -b 0.0.0.0
	•	redis-server
	•	bundle exec sidekiq
	•	

##### 18. Open localhost:3000 in browser

