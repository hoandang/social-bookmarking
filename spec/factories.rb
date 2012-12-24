FactoryGirl.define do
  factory :user do
    name 'Michael Hartl'
    email 'michael@gmail.com'
    password 'foobar'
    password_confirmation 'foobar'
  end
end
