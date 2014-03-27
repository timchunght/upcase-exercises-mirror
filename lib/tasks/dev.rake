namespace :dev do
  desc 'Create sample data for local development'
  task prime: ['db:setup'] do
    unless Rails.env.development?
      raise 'This task can only be run in the development environment'
    end

    require 'factory_girl_rails'

    create_exercises
  end

  def create_exercises
    header "Exercises"

    exercise = FactoryGirl.create(
      :exercise,
      title: 'Shakespeare Analyzer',
      body: 'As a Shakespeare buff, do this exercise'
    )

    puts_exercise exercise

    exercise = FactoryGirl.create(
      :exercise,
      title: "Ask don't tell",
      body: "Tell me how you ask."
    )
    puts_exercise exercise

    exercise = FactoryGirl.create(
      :exercise,
      title: 'Leap Year',
      body: "Write a program that tells you whether or not a given year is a " +
        "leap year. Remember the following leap year constraints. Leap year is" +
        "every four years, but skips every one hundred, but is a leap year " +
        "every four hundred"
    )
    puts_exercise exercise
  end

  private

  def header(msg)
    puts "\n\n*** #{msg.upcase} *** \n\n"
  end

  def puts_exercise(exercise)
    puts exercise.title
  end
end
