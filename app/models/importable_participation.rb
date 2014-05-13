class ImportableParticipation < SimpleDelegator
  def initialize(participation, arguments)
    super(participation)
    @participation = participation
    @git_server = arguments[:git_server]
    @shell = arguments[:shell]
  end

  def import(diff)
    if unsolved?
      patch = write_patch(diff)
      clone = Git::Clone.new(participation.find_or_create_clone, git_server)
      clone.repository.commit('Import solution from GitHub') do
        shell.execute("patch -p1 < #{patch.path}")
      end
      participation.find_or_create_solution
    end
  end

  private

  attr_reader :git_server, :participation, :shell

  def unsolved?
    !participation.has_solution?
  end

  def write_patch(contents)
    Tempfile.new('patch').tap do |tempfile|
      tempfile.write(contents)
      tempfile.flush
    end
  end
end
