require 'spec_helper'

describe Repository do
  describe '#==' do
    it 'returns true if the hosts and paths are equal' do
      expect(repo(host: 'example.com', path: 'user/repo'))
        .to eq(repo(host: 'example.com', path: 'user/repo'))
    end

    it 'returns false if the hosts are unequal' do
      expect(repo(host: 'example.com', path: 'user/repo'))
        .not_to eq(repo(host: 'different.com', path: 'user/repo'))
    end

    it 'returns false if the paths are unequal' do
      expect(repo(host: 'example.com', path: 'user/repo'))
      .not_to eq(repo(host: 'example.com', path: 'user/other'))
    end

    it 'returns false when compared to a non-repository' do
      expect(repo(host: 'example.com', path: 'user/repo'))
      .not_to eq(Object.new)
    end

    def repo(attributes)
      Repository.new(attributes)
    end
  end

  describe '#name' do
    it 'returns the last component of its path' do
      repository = Repository.new(host: 'example.com', path: 'path/to/repo')

      expect(repository.name).to eq('repo')
    end
  end

  describe '#path' do
    it 'returns its path' do
      repository = Repository.new(host: 'example.com', path: 'some/path')

      expect(repository.path).to eq('some/path')
    end
  end

  describe '#url' do
    it 'uses the host and path to generate a full Git URL' do
      repository = Repository.new(host: 'example.com', path: 'user/repo')

      url = repository.url

      expect(url).to eq('git@example.com:user/repo.git')
    end
  end
end
