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

  sequence :title do |n|
    "Title #{n} Text"
  end

  factory :clone do
    exercise
    user
  end

  factory :exercise do
    title
    body 'Body'
  end

  factory :git_server do
    host 'localhost'
    shell { FakeShell.new }

    initialize_with { GitServer.new(shell, host) }
    to_create {}
  end

  factory :user do
    auth_token
    email
    first_name 'Joe'
    last_name 'User'
    learn_uid
    username 'username'

    factory :admin do
      admin true
    end

    factory :subscriber do
      admin false
    end
  end
end
