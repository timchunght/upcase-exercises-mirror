# Yields source repositories for each exercise in the collection.
class SourceCollection
  include Enumerable

  def initialize(exercises)
    @exercises = exercises
  end

  def each(&block)
    sources.each(&block)
  end

  private

  def sources
    @exercises.map do |exercise|
      GIT_SERVER.source(exercise)
    end
  end
end
