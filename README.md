* Prerequisites

The setups steps expect following to be installed on the system.

- Github
- Ruby 3.2.0
- Rails 7.0.6
- postgres

Note :- 
Preferred way is to use rvm or rbenv as this way you can manage between different versions of ruby

Using rvm (optional)

rvm install ruby 3.2.0

rvm 3.2.0@rails-pizza-challenge  --create

rvm gemset list

rvm gemset use rails-pizza-challenge

gem install rails -v 7.0.6

* Clone the repository

git clone https://github.com/mahakhalid/rails-pizza-challenge_app.git

* Create database.yml file

Copy the sample database.yml file and edit the database configuration as required.

* Create and setup the database

create postgres user and password and add into environment file such as shown in .env.example

rails db:setup command will create the database, load the schema, and initialize it with the seed data.

Alternatively you can do the following

rails db:create
rails db:migrate

To populate database with data given in data/orders.json file

rails db:seed

* How to run the test suite

- To run all test cases

rspec spec

- To run specific file test cases

rspec relative_path_to_file

- To run specific test case in a file

rspec relative_path_to_file:line_number

* Start the Rails server

You can start the rails server using the command given below.

rails s

Hurray! you can now visit the site with the URL http://localhost:3000
