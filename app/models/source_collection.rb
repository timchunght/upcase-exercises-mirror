# Yields source repositories for each exercise in the collection.
class SourceCollection
  include Enumerable

  pattr_initialize :exercises, :git_server

  def each(&block)
    sources.each(&block)
  end

  private

  def sources
    exercises.map do |exercise|
      git_server.source(exercise)
    end
  end
end
