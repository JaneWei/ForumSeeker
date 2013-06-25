namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do#ensure that rake task has access to evn
    admin = User.create!(name: "Admin",
                 email: "internproject@hotmail.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    admin.toggle!(:admin) 
    9.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@silverspringnet.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
