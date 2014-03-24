class GitoliteConfig
  TEMPLATE_PATH =
    Rails.root.join('app', 'views', 'gitolite_config', 'gitolite.conf.erb')

  def initialize(root)
    @root = root
  end

  def write
    open_config_file do |file|
      file.puts evaluate_template
    end
  end

  private

  def open_config_file(&block)
    File.open(config_path, 'w', &block)
  end

  def config_path
    File.join(@root, 'config/gitolite.conf')
  end

  def evaluate_template
    ERB.new(template_contents).result(binding).strip
  end

  def template_contents
    IO.read(TEMPLATE_PATH)
  end

  def usernames
    User.by_username.map(&:username)
  end
end
