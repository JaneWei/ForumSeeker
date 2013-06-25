#Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ForumWarrior::Application.initialize!
 
ActionMailer::Base.delivery_method = :smtp;

ActionMailer::Base.smtp_settings = {
:address => "smtp.gmail.com",
:port => 587,
:domain => "glacial-dusk-5436.herokuapp.com",
:authentication => :plain,
:user_name => "tomatoisfurious",
:password => "furiousfoobar",
}
