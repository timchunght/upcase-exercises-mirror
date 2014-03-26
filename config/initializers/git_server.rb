server_bin_path = Rails.root.join('server_bin').expand_path.to_s
Cocaine::CommandLine.path = server_bin_path

# The default runner doesn't correctly use the overridden path.
# See https://github.com/thoughtbot/cocaine/issues/63
Cocaine::CommandLine.runner = Cocaine::CommandLine::BackticksRunner.new

host = ENV['GIT_SERVER_HOST']

if Rails.env.test?
  base_shell = FakeShell.new
else
  base_shell = Shell.new
end

identified_shell = IdentifiedShell.new(base_shell, ENV['IDENTITY'])

sources = SourceCollection.new(ReloadingCollection.new(Exercise.alphabetical))

config_writer = GitoliteConfigWriter.new(ENV['PUBLIC_KEY'], sources)

config_committer = GitoliteConfigCommitter.new(
  host: host,
  shell: identified_shell,
  writer: config_writer
)

GIT_SERVER = GitServer.new(
  shell: identified_shell,
  host: host,
  config_committer: config_committer
)
