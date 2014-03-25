require 'spec_helper'

describe GitoliteConfigWriter do
  describe '#write' do
    it 'writes the template into the given directory' do
      in_config_dir do
        stub_users([{ username: 'one' }, { username: 'two' }])
        config = GitoliteConfigWriter.new

        config.write

        result = IO.read('config/gitolite.conf')
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

  def in_config_dir
    Dir.mktmpdir do |path|
      FileUtils.chdir(path) do
        FileUtils.mkdir(File.join(path, 'config'))
        yield
      end
    end
  end

  def stub_users(attributes_collection)
    users = attributes_collection.map do |attributes|
      stub_user(attributes)
    end

    User.stub(:by_username).and_return(users)
  end

  def stub_user(attributes)
    double(
      'user',
      username: attributes[:username] || 'mruser'
    )
  end
end
