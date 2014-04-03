class RepositoryRevision
  pattr_initialize :shell, :clonable

  def head
    clonable.clone do
      shell.execute('git rev-parse HEAD')
    end
  end
end
