# Yields source repositories for each exercise in the collection.
class SourceCollection
  include Enumerable

  def initialize(exercises, git_server)
    @exercises = exercises
    @git_server = git_server
  end

  def each(&block)
    sources.each(&block)
  end

  private

  def sources
    @exercises.map do |exercise|
      @git_server.source(exercise)
    end
  end
end
