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

  factory :clone do
    exercise
    user
    parent_sha '123456789'
  end

  factory :exercise do
    title
    body 'Body'
  end

  factory :git_server, class: 'Gitolite::Server' do
    host 'localhost'
    repository_factory { Git::Repository }
    shell { Gitolite::FakeShell.new }

    initialize_with { new(attributes) }
    to_create {}
  end

  factory :solution do
    clone

    trait :with_revision do
      revisions { [build(:revision)] }
    end
  end

  factory :viewable_solution do
    solution factory: [:solution, :with_revision]
    active false
    assigned false

    to_create {}
    initialize_with do
      ViewableSolution.new(solution, active: active, assigned: assigned)
    end
  end

  factory :user do
    auth_token
    avatar_url 'https://gravat.ar/'
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
  factory :revision do
    solution
    diff 'diff deploy.rb'
  end
end
