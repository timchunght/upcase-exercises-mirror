namespace :dev do
  desc 'Create sample data for local development'
  task prime: ['db:setup'] do
    if Rails.env.production?
      raise 'This task cannot be run in the production environment'
    end

    require 'factory_girl_rails'

    create_users
    create_exercises
    create_solutions
    display_exercise_statuses
  end

  def create_exercises
    header "Exercises"

    exercise = FactoryGirl.create(
      :exercise,
      title: 'Shakespeare Analyzer',
      instructions: 'As a Shakespeare buff, do this exercise'
    )

    puts_exercise exercise

    exercise = FactoryGirl.create(
      :exercise,
      title: "Ask don't tell",
      instructions: "Tell me how you ask."
    )
    puts_exercise exercise

    exercise = FactoryGirl.create(
      :exercise,
      title: 'Leap Year',
      instructions: "Write a program that tells you whether or not a given year is a " +
        "leap year. Remember the following leap year constraints. Leap year is" +
        "every four years, but skips every one hundred, but is a leap year " +
        "every four hundred"
    )
    puts_exercise exercise
  end

  def create_users
    header "Users"

    user = FactoryGirl.create(
      :admin,
      email: "admin@example.com",
      first_name: "Admin",
      username: "admin",
      upcase_uid: upcase_user_id_for("admin@example.com")
    )
    FactoryGirl.create(:public_key, user: user, pending: false)
    puts_user user, "admin, with public key"

    user = FactoryGirl.create(
      :admin,
      email: "whetstone@example.com",
      first_name: "Whetstone",
      username: "whetstone",
      upcase_uid: upcase_user_id_for("whetstone@example.com")
    )
    FactoryGirl.create(:public_key, user: user, pending: false)
    puts_user user, "whetstone, with public key"

    user = FactoryGirl.create(
      :subscriber,
      email: "basic@example.com",
      first_name: "Basic",
      username: "basic",
      upcase_uid: upcase_user_id_for("basic@example.com")
    )
    puts_user user, "basic, without public key"
  end

  def create_solutions
    header "Solutions"

    exercises = Exercise.limit(2).to_a
    admin = User.find_by_username!("admin")
    whetstone = User.find_by_username!("whetstone")
    basic_user = User.find_by_username!("basic")

    create_solution(exercise: exercises[0], user: basic_user)
    create_solution(exercise: exercises[1], user: admin)
    create_solution(exercise: exercises[1], user: whetstone)
  end

  def display_exercise_statuses
    header "Exercise Statuses"

    whetstone = User.find_by_username!("whetstone")

    puts "=> No solution"
    Exercise.includes(:solutions).each do |exercise|
      if exercise.solutions.empty?
        puts_exercise exercise
      end
    end

    puts "\n=> Submitted by Whetstone:"
    Exercise.includes(:clones).each do |exercise|
      if exercise.clones.any? { |clone| clone.user == whetstone }
        puts_exercise exercise
      end
    end

    puts "\n=> Waiting for review by Whetstone:"
    Exercise.includes(:solutions).each do |exercise|
      if exercise.clones.any? { |clone| clone.user != whetstone }
        puts_exercise exercise
      end
    end
  end

  private

  def header(msg)
    puts "\n\n*** #{msg.upcase} *** \n\n"
  end

  def puts_exercise(exercise)
    puts exercise.title
  end

  def puts_user(user, description)
    puts "#{user.email} (#{description})"
  end

  def puts_solution(solution)
    puts "Solution by #{solution.clone.user.username.capitalize} on " +
      "#{solution.clone.exercise.title}"
  end

  def create_solution(exercise:, user:)
    clone = FactoryGirl.create(:clone, exercise: exercise, user: user)
    solution = FactoryGirl.create(:solution, clone: clone)
    solution.revisions = [FactoryGirl.create(:revision, solution: solution)]
    puts_solution solution
  end

  def upcase_user_id_for(email)
    upcase_connection.select_value <<-SQL.squish
      SELECT id
      FROM users
      WHERE email = '#{email}'
    SQL
  end

  def upcase_connection
    @upcase_connection ||= UpcaseConnection.tap do |klass|
      klass.establish_connection(
        ActiveRecord::Base.configurations[Rails.env].merge(
          "database" => "upcase_development"
        )
      )
    end.connection
  end

  UpcaseConnection = Class.new(ActiveRecord::Base)
end
