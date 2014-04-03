class FakeClonableRepository

  def clone
    in_temp_dir do
      yield
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
