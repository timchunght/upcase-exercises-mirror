# Reloads the given relation before yielding results so that the records always
# reflect the latest from the database.
class ReloadingCollection
  include Enumerable

  def initialize(relation)
    @relation = relation
  end

  def each(&block)
    @relation.reload.each(&block)
  end
end
