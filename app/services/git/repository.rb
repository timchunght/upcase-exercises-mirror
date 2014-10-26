module Git
  # Value object for a Git repository.
  class Repository
    include ActiveModel::Conversion

    def initialize(attributes)
      @host = attributes[:host]
      @path = attributes[:path]
    end

    def name
      File.basename(path)
    end

    def url
      "git@#{host}:#{path}.git"
    end

    attr_reader :path, :host
  end
end
