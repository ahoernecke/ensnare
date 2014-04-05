Ensnare
=======
Ensnare is packaged as a gem plugin for Ruby on Rails and was developed to allow configuring and deploying a basic malicious behavior detection and response scheme in less than ten minutes.

Ensnare uses a combination of [Honey Traps](https://github.com/ahoernecke/Ensnare/wiki#honey-traps) to entice malicious users, and a configurable suite of [Trap Responses](https://github.com/ahoernecke/Ensnare/wiki#response-types) to confuse, allude, delay, or stop an attacker.

Already heard about the tool and want to try it out?  Do it!

#Install#

Add the gem to your project's Gemfile:
```ruby
    gem 'ensnare', :git => 'git@github.com:ahoernecke/Ensnare.git'
```
Install the gem:
```shell
    bundle install
```
Run the migrations for Ensnare:
```shell
    rake ensnare:install:migrations
    rake db:migrate
```
Enable parameter tampering for your application by changing the mass_assignment_sanitizer:
```shell
    vi config/environments/<ENVIRONMENT>.rb
```  
Set config.active_record.mass_assignment_sanitizer to logger:
```ruby
    config.active_record.mass_assignment_sanitizer = :logger 
```   
Enable Ensnare in your application_controller.rb file:
```shell
    vi app/controllers/application_controller.rb
```    
Append the following filter below *protect_from_forgery* in your application_controller.rb file:
```ruby
    before_filter :ensnare
```
Add the following to the end of your routes.rb file:
```ruby
    mount Ensnare::Engine => "/ensnare", :as => "ensnare_engine" 
    match "*_", :to => "ensnare::violations#routing_error"
```
Create an Ensnare config file:
```shell
    rails g ensnare:install
```
Take a look at the example ensnare.rb file:
```shell    
    vi config/initializes/ensanre.rb
```
After you start your application, take a look at the dashboard:

    http://your-application.com/ensnare/dashboard

In order to access the dashboard, this step needs to be performed.   

To prevent unnecessary users from accessing the dashboard, add the following to the `config/initalizers/ensanre.rb` file:
```ruby
  config.dashboard_user_method = :current_user
  config.dashboard_authorization_method = :admin?
```
 *NOTE:* you need to have a method defined to check if the user is the admin.
 
#Bugs#

[Dashboard CSS Issues in Firefox](https://github.com/ahoernecke/ensnare/issues/1)

#Resources#

http://books.google.com/books?id=flC9dFFLWIsC&pg=PT111&lpg=PT111&dq=honey+trap+mod+security&source=bl&ots=zKxJvehMpA&sig=E9qKn7L4siEk01caEF6wqofbbm8&hl=en&sa=X&ei=_iRUUoCRJKPiiwK8y4HIBA&ved=0CFUQ6AEwBg#v=onepage&q=honey trap mod security&f=false

##Contact##
Created by [Andy Hoernecke](https://github.com/ahoernecke) and [Scott Behrens](https://github.com/sbehrens).

Feel free to reach out to us if you have questions or want to contribute to the project!
