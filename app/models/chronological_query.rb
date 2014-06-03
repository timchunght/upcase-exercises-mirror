class ChronologicalQuery
  include Enumerable

  def initialize(relation)
    @relation = relation
  end

  def each(&block)
    @relation.order(created_at: :asc).each(&block)
  end
end
