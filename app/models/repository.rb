class Repository
  include ActiveModel::Conversion

  attr_reader :slug

  def initialize(slug)
    @slug = slug
  end

  def exercise_path
    "sources/#{@slug}"
  end
end
