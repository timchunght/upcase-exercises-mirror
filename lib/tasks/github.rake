namespace :github do
  desc 'Import solutions to an exercise from GitHub'
  task import: :environment do
    exercise = Exercise.find(ENV['EXERCISE'])
    dependencies = Dependencies::RailsLoader.
      load.
      service(:logger) { Logger.new(STDERR) }
    dependencies[:github_exercise].new(
      github_repository: ENV['REPO'],
      local_exercise: exercise,
    ).import
  end
end
