server_bin_path = Rails.root.join('server_bin').expand_path.to_s
Cocaine::CommandLine.path = server_bin_path

if Rails.env.test?
  base_shell = FakeShell.new
else
  base_shell = Shell.new
end

identified_shell = IdentifiedShell.new(base_shell, ENV['IDENTITY'])

GIT_SERVER = GitServer.new(identified_shell, ENV['GIT_SERVER_HOST'])
