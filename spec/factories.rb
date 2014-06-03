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

  factory :comment do
    user
    solution
    text 'body'
    location { Comment::TOP_LEVEL }
  end

  factory :exercise do
    title
    instructions 'Instructions'
    intro 'Introduction'
  end

  factory :git_server, class: 'Gitolite::Server' do
    host 'localhost'
    repository_factory { Git::Repository }
    shell { Gitolite::FakeShell.new }

    initialize_with { new(attributes) }
    to_create {}
  end

  factory :repository, class: 'Git::Repository' do
    host 'example.com'
    path 'repo.git'
    initialize_with { new(attributes) }
    to_create {}
  end

  factory :solution do
    clone

    trait :with_revision do
      revisions { [build(:revision)] }
    end

    after :stub do |solution, attributes|
      solution.stub(:exercise).and_return(attributes.clone.exercise)
      solution.stub(:user).and_return(attributes.clone.user)
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
    diff <<-DIFF.strip_heredoc
      diff --git a/spec/factories.rb b/spec/factories.rb
      index 7794c81..fe91a1b 100644
      --- a/spec/factories.rb
      +++ b/spec/factories.rb
      @@ -84,6 +84,6 @@ FactoryGirl.define do
       end
       factory :revision do
       solution
      -    diff 'diff deploy.rb'
      +    diff another diff
       end
       end
    DIFF
  end
end
