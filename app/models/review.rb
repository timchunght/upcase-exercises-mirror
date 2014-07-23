# Facade which composes facades for the review page.
class Review
  pattr_initialize([ :exercise!, :feedback!, :solutions!, :status!])
  attr_reader :exercise, :feedback, :solutions, :status
end
