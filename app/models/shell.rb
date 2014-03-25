# Shell adapter for Cocaine.
class Shell
  def execute(*terms)
    Cocaine::CommandLine.new(*terms).run
  end
end
