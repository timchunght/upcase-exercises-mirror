require 'spec_helper'

describe GitoliteConfig do
  describe '#write' do
    it 'writes the template into the given directory' do
      Dir.mktmpdir do |path|
        users = [
          double('user', username: 'one'),
          double('user', username: 'two')
        ]
        User.stub(:by_username).and_return(users)
        FileUtils.mkdir(File.join(path, 'config'))
        config = GitoliteConfig.new(path)

        config.write

        result = IO.read(File.join(path, 'config/gitolite.conf'))
        expect(result).to eq(<<-CONFIG.strip_heredoc)
          @admins = server

          repo gitolite-admin
              RW+     =   @admins

          repo [a-zA-Z0-9].*
              RW+     =   @admins
              C       =   @admins


          repo one/.*
              RW master = one

          repo two/.*
              RW master = two
        CONFIG
      end
    end
  end
end
