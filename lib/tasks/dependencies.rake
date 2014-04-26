namespace :dependencies do
  if Rails.env.development?
    require 'yard'

    YARD::Rake::YardocTask.new(:docs) do |task|
      task.files = ['lib/dependencies']
      task.options = ['-r', 'lib/dependencies/README.md', '-o', 'doc/dependencies']
    end
  end
end
