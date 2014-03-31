# Extends Solution to be aware of its status in relation to a viewer and other
# solutions to the same exercise.
class ViewableSolution < SimpleDelegator
  def initialize(solution, attributes)
    super(solution)
    @active = attributes.fetch(:active)
    @assigned = attributes.fetch(:assigned)
  end

  def active?
    @active
  end

  def assigned?
    @assigned
  end
end
