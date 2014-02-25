FactoryGirl.define do
  sequence :auth_token do |n|
    Digest::MD5.hexdigest("token#{n}")
  end

  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :learn_uid do |n|
    n
  end

  factory :exercise do
    title 'Title'
    body 'Body'
  end

  factory :user do
    auth_token
    email
    first_name 'Joe'
    last_name 'User'
    learn_uid
  end
end
