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

  sequence :username do |n|
    sprintf('username%04d', n)
  end

  factory :gitolite_config_committer do
    host 'localhost'
    shell { FakeShell.new }
    writer { GitoliteConfigWriter.new('ssh-rsa key', []) }

    initialize_with { GitoliteConfigCommitter.new(attributes) }
    to_create {}
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
    association :config_committer, factory: :gitolite_config_committer
    host 'localhost'
    shell { FakeShell.new }

    initialize_with { GitServer.new(attributes) }
    to_create {}
  end

  factory :solution do
    clone
  end

  factory :viewable_solution do
    solution
    active false
    assigned false

    to_create {}
    initialize_with do
      ViewableSolution.new(solution, active: active, assigned: assigned)
    end
  end

  factory :user do
    auth_token
    email
    first_name 'Joe'
    last_name 'User'
    learn_uid
    username

    factory :admin do
      admin true
    end

    factory :subscriber do
      admin false
    end
  end
end
