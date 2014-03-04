if Rails.env.test?
  GIT_SERVER = GitServer.new(FakeShell.new, ENV['GIT_SERVER_HOST'], '/tmp')
else
  GIT_SERVER = GitServer.new(Shell.new, ENV['GIT_SERVER_HOST'], '/tmp')
end
