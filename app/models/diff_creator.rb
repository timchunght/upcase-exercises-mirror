class DiffCreator
  pattr_initialize :shell, :clonable

  def diff(sha)
    clonable.clone do
      shell.execute("git diff #{sha} --unified=10000")
    end
  end
end
