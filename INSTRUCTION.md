# phylotastic-portal

This is the main repository for developing a generalized web UI for phylotastic services.  

Some design documents, including a workflow, are in the design folder, and there is also a [dynamic mockup](http://lumzy.com/access/?id=FC2B5EEE16DB5F9E5192490824153E60). 

## Installation 

##### 1. Install necessary libraries

`sudo apt-get install build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs`

##### 2. Install Ruby and Rails

`sudo apt-get update`

`sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev`

`cd`

`git clone git://github.com/sstephenson/rbenv.git .rbenv`

`echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc`

`echo 'eval "$(rbenv init -)"' >> ~/.bashrc`

`git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build`

`echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc`

`source ~/.bashrc`

`rbenv install -v 2.3.0`

`rbenv global 2.3.0`

`echo "gem: --no-document" > ~/.gemrc`

`gem install bundler`

`gem install rails -v 4.2.3`

`rbenv rehash`

The above commands are extracted from [this installation tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04).

##### 3. Install Javascript runtime

`sudo add-apt-repository ppa:chris-lea/node.js`

`sudo apt-get update`

`sudo apt-get install nodejs`

##### 4. Install redis

`sudo apt-get install redis-server`

##### 5. Generate SSH (optional, in case you want to contribute code to the portal)

`ssh-keygen -t rsa -b 4096 -C "your_email@mail.com"`

`eval "$(ssh-agent -s)"`

`ssh-add ~/.ssh/id_rsa`

`cat $HOME/.ssh/id_rsa.pub`

##### 6. Get the phylotastic portal code from github

`git clone https://github.com/phylotastic/phylotastic-portal.git`

##### 7. Install any needed ruby gems. 

* In top level of repository 

`cd phylotastic-portal`

`sudo apt-get install postgresql`

`sudo apt-get install libpq-dev`

`bundle install`

##### 8. Config database

* Make a postgres user.  You will be prompted for a password.

`createuser -PSDR portal-app` 

* Make the db

`createdb -O portal-app phylotastic-portal` 

* Set up the config file that the app will use 
  
`cp config/database.yml.example config/database.yml`
    
* THe portal need password to access the database. Edit the password field in database.yml as password for postgres user. 

##### 9. Create tables in database

   `rake db:migrate`

##### 10. Contact us for config.yml
  
##### 11. To run, execute the following commands in separate terminals: 
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

   `$ gem install rails -v 4.2.3`
   
   `$ rbenv rehash`

##### 5.Check the location where gems are being installed with gem env:

   `$ gem env home`

   `# => ~/.rbenv/versions/<ruby-version>/lib/ruby/gems/…`

##### 6. Get the phylotastic portal code from github
   
   `git clone https://github.com/phylotastic/phylotastic-portal.git`

#####7. Generate SSH (optinal)
   `ssh-keygen -t rsa -b 4096 -C "your_email@pikachu.com"`

   `eval "$(ssh-agent -s)"`

   `ssh-add ~/.ssh/id_rsa`

   `cat $HOME/.ssh/id_rsa.pub`

Add ssh key to your account if you want to contribute

##### 8. Install any needed ruby gems.
`cd phylotastic-portal`

`bundle install`


##### 9. Install database

`brew install postgres`

`brew services`

`gem install pg`

##### 10. Run background database

 `brew services start postgresql`

##### 11 Config database
  * Make a postgres user.  You will be prompted for a password.

  `createuser -PSDR portal-app` 

  * Make the db

  `createdb -O portal-app phylotastic-portal` 

  * Set up the config file that the app will use 
  
  `cp config/database.yml.example config/database.yml`
    
  * THe portal need password to access the database. Edit the password field in database.yml as password for postgres user.
		
##### 12. Create tables in database

   `rake db:migrate`

##### 13. Contact us for config.yml

##### 14. To run, execute the following commands in separate terminals:
	•	rails server -b 0.0.0.0
	•	redis-server
	•	bundle exec sidekiq
	•	

##### 15. Open localhost:3000 in browser

