module Features
  class ExerciseWorkflow
    include Rails.application.routes.url_helpers
    include FactoryGirl::Syntax::Methods

    self.default_url_options = { host: 'www.example.com' }

    def initialize(page, options = {})
      @page = page
      @exercise = options[:exercise] || create(:exercise)
      username = options[:username] || 'myuser'
      @user = options[:user] || create(:user, username: username)
    end

    def submit_solution(filename = 'example.txt')
      create(:clone, user: user, exercise: exercise)
      page.visit exercise_clone_path(exercise, as: user)
      stub_diff_command(filename) do
        page.click_on I18n.t('clones.show.submit_solution')
      end
    end

    def update_solution(filename)
      stub_diff_command(filename) do
        with_api_client do |client|
          client.post api_pushes_url(user, exercise)
        end
      end
    end

    def view_my_solution
      page.click_on I18n.t('solutions.show.my_solution')
    end

    def view_solution_by(username)
      page.click_on I18n.t(
        'solutions.show.solution_for_user',
        username: username
      )
    end

    def create_solution_by_other_user(options = {})
      diff = generate_diff(options[:filename] || 'otherfile.txt')
      user = create(:user, username: options[:username] || 'otheruser')
      clone = create(:clone, user: user, exercise: exercise)
      create(:solution, clone: clone).tap do |solution|
        create(:revision, diff: diff, solution: solution)
      end
    end

    private

    attr_reader :exercise, :page, :user

    def stub_diff_command(filename)
      Gitolite::FakeShell.with_stubs do |stubs|
        stubs.add(%r{git diff}) do
          generate_diff(filename)
        end

        yield
      end
    end

    def generate_diff(filename)
      <<-DIFF.strip_heredoc
        diff --git a/#{filename} b/#{filename}
        new file mode 100644
        index 0000000..8e1fbbd
        --- /dev/null
        +++ b/#{filename}
        +New file
      DIFF
    end

    def with_api_client
      Capybara.using_session 'api_client' do
        yield Capybara.current_session.driver
      end
    end
  end

  def start_exercise_workflow(*args)
    ExerciseWorkflow.new(page, *args)
  end
end