require 'spec_helper'

describe GitoliteConfigWriter do
  describe '#write' do
    it 'writes the template into the given directory' do
      in_config_dir do
        stub_users(
          [{ username: 'one' }, { username: 'two' }],
          admin_usernames: %w(apple berry)
        )
        sources = stub_sources(%w(sources/adam sources/billy))
        config = GitoliteConfigWriter.new('ssh-rsa server', sources)

        config.write

        result = IO.read('conf/gitolite.conf')
        expect(result).to eq(<<-CONFIG.strip_heredoc)
          @admins = server apple berry

          repo gitolite-admin
              RW+     =   @admins


          repo sources/adam
              RW+     =   @admins

          repo sources/billy
              RW+     =   @admins


          repo one/.*
              RW master = one

          repo two/.*
              RW master = two
        CONFIG
      end
    end

    it 'rewrites the public key directory' do
      in_config_dir do
        create_preexisting_key

        stub_users([
          {
            username: 'one',
            public_keys: [
              stub_key(1, 'abc'),
              stub_key(2, 'def')
            ]
          },
          {
            username: 'two',
            public_keys: [
              stub_key(3, 'ghi')
            ]
          }
        ])
        sources = stub_sources
        config = GitoliteConfigWriter.new('ssh-rsa server', sources)

        config.write

        expect(existing_keys).to eq(
          '1/one.pub' => 'abc',
          '2/one.pub' => 'def',
          '3/two.pub' => 'ghi',
          'server.pub' => 'ssh-rsa server'
        )
      end
    end
  end

  def in_config_dir
    Dir.mktmpdir do |path|
      FileUtils.chdir(path) do
        FileUtils.mkdir('conf')
        yield
      end
    end
  end

  def stub_users(attributes_collection, options = {})
    users = attributes_collection.map do |attributes|
      stub_user(attributes)
    end

    User.stub(:by_username).and_return(users)
    User.stub(:admin_usernames).and_return(options[:admin_usernames] || [])
  end

  def stub_user(attributes)
    double(
      'user',
      username: attributes[:username] || 'mruser',
      public_keys: attributes[:public_keys] || []
    )
  end

  def stub_sources(paths = [])
    paths.map do |path|
      double('source', path: path)
    end
  end

  def create_preexisting_key
    FileUtils.mkdir('keydir')
    File.open('keydir/preexisting.pub', 'w') do |file|
      file.puts 'pre-existing key'
    end
  end

  def stub_key(id, data)
    double('public_key', id: id, data: data)
  end

  def existing_keys
    Dir.glob('keydir/**/*.*').inject({}) do |result, path|
      key = path.sub(%r{^keydir/}, '')
      result.update(key => IO.read(path).chop)
    end
  end
end
