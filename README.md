# phylotastic-portal

This is the main repository for developing a generalized web UI for phylotastic services.  

Some design documents, including a workflow, are in the design folder, and there is also a [dynamic mockup](http://lumzy.com/access/?id=FC2B5EEE16DB5F9E5192490824153E60). 

## Installation 

1. Install necessary libraries

`sudo apt-get install build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs`

2. Install Ruby

https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04

`sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
cd`
`git clone git://github.com/sstephenson/rbenv.git .rbenv`
`echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile`
`echo 'eval "$(rbenv init -)"' >> ~/.bash_profile`

`git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build`
`echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile`
`source ~/.bash_profile`
`rbenv install -v 2.2.1`
`rbenv global 2.2.1`
`echo "gem: --no-document" > ~/.gemrc`
`gem install bundler`
`gem install rails`
`rbenv rehash`

3. Install Javascript runtim

`sudo add-apt-repository ppa:chris-lea/node.js`
`sudo apt-get update`
`sudo apt-get install nodejs`
`sudo apt-get install redis-server`

4. Install Rails

5. Install redis and sidekiq

6. Generate SSH (if you didnot have one)

`ssh-keygen -t rsa -b 4096 -C "your_email@pikachu.com"`
`eval "$(ssh-agent -s)"`
`ssh-add ~/.ssh/id_rsa`
`cat $HOME/.ssh/id_rsa.pub`

7. Clone code from repo

8. Run `bundle install at the top level of this repository to install any needed ruby gems. 

9. Config database
  * First, use database.yml.example as a template 
  
  `cp config/database.yml.example database.yml`
  
  * Then change parameters as you want
  
10. To run, execute the following commands in separate terminals: 
  * `rails server`
  * `redis-server`
  * `bundle exec sidekiq`

