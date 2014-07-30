class ObservingParticipation < SimpleDelegator
  def initialize(participation, observer)
    super(participation)
    @observer = observer
  end

  def create_clone
    observer.clone_created
    super
  end

  def find_or_create_solution
    observer.solution_submitted
    super
  end

  def push_to_clone
    observer.revision_submitted
    super
  end

  private

  attr_reader :observer
end
