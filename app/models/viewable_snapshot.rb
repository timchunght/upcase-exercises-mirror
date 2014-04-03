class ViewableSnapshot < SimpleDelegator
  def files
    split.map do |file|
      StringIO.new(file)
    end
  end

  private

  def split
    diff.split(/\ndiff/)
  end
end
