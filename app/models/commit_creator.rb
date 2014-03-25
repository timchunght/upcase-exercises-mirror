class CommitCreator
  def initialize(shell, repository)
    @shell = shell
    @repository = repository
  end

  def commit(message)
    in_temp_dir do
      clone do
        yield
        add_to_index
        create_commit(message)
        push
      end
    end
  end

  private

  def in_temp_dir
    Dir.mktmpdir do |path|
      FileUtils.cd path do
        yield
      end
    end
  end

  def clone(&block)
    @shell.execute("git clone #{@repository.url} local")
    FileUtils.cd('local', &block)
  end

  def add_to_index
    @shell.execute('git add -A')
  end

  def create_commit(message)
    @shell.execute(%{git commit -m "#{message}"})
  end

  def push
    @shell.execute('git push')
  end
end
