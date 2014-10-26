require "spec_helper"

describe Git::Repository do
  describe "#fingerprint" do
    it "returns its fingerprint" do
      repository = repo(fingerprint: "02:12:13")

      expect(repository.fingerprint).to eq("02:12:13")
    end
  end

  describe "#host" do
    it "returns its host" do
      repository = repo(host: "example.com")

      expect(repository.host).to eq("example.com")
    end
  end

  describe "#name" do
    it "returns the last component of its path" do
      repository = repo(path: "path/to/repo")

      expect(repository.name).to eq("repo")
    end
  end

  describe "#path" do
    it "returns its path" do
      repository = repo(path: "some/path")

      expect(repository.path).to eq("some/path")
    end
  end

  describe "#url" do
    it "uses the host and path to generate a full Git URL" do
      repository = repo(host: "example.com", path: "user/repo")

      url = repository.url

      expect(url).to eq("git@example.com:user/repo.git")
    end
  end

  def repo(host: "example.com", path: "user/repo",
      fingerprint: "bc:09:e9:de:68:04:04:5f:2f:0d:da:b7:d2:ac:3a:2a")
    Git::Repository.new(host: host, path: path, fingerprint: fingerprint)
  end
end
