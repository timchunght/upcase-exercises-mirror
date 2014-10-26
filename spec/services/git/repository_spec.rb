require 'spec_helper'

describe Git::Repository do
  describe '#host' do
    it 'returns its host' do
      repository = Git::Repository.new(host: 'example.com', path: 'user/repo')

      expect(repository.host).to eq('example.com')
    end
  end

  describe '#name' do
    it 'returns the last component of its path' do
      repository =
        Git::Repository.new(host: 'example.com', path: 'path/to/repo')

      expect(repository.name).to eq('repo')
    end
  end

  describe '#path' do
    it 'returns its path' do
      repository = Git::Repository.new(host: 'example.com', path: 'some/path')

      expect(repository.path).to eq('some/path')
    end
  end

  describe '#url' do
    it 'uses the host and path to generate a full Git URL' do
      repository = Git::Repository.new(host: 'example.com', path: 'user/repo')

      url = repository.url

      expect(url).to eq('git@example.com:user/repo.git')
    end
  end
end
