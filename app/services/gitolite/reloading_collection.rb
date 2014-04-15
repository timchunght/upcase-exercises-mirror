module Gitolite
  # Reloads the given relation before yielding results so that the records
  # always reflect the latest from the database.
  class ReloadingCollection
    include Enumerable

    pattr_initialize :relation

    def each(&block)
      relation.reload.each(&block)
    end
  end
end
