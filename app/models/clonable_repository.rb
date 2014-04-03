class ClonableRepository
  pattr_initialize :shell, :repository

  def clone(&block)
    in_temp_dir do
      shell.execute("git clone #{repository.url} local")
      Dir.chdir('local', &block)
    end
  end

  private

  def in_temp_dir
    Dir.mktmpdir do |path|
      Dir.chdir path do
        yield
      end
    end
  end
end
