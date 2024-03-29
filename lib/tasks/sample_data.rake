namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_bookmarks
    make_relationships
  end

  def make_users
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end

  def make_bookmarks
    50.times do
      User.all(limit: 6).each do |user|
        user.bookmarks.create!(title: Faker::Lorem.sentence, 
                              url: Faker::Internet.url,
                              description: Faker::Lorem.paragraph)
      end
    end
  end

  def make_relationships
    users = User.all
    user  = users.first
    followed_users = users[2..50]
    followers      = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each      { |follower| follower.follow!(user) }
  end
end
