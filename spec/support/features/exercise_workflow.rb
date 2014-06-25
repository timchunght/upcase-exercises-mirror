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

    def start_exercise(public_keys: ['ssh-rsa 123'])
      public_keys.each { |data| create_public_key(data: data) }
      page.visit exercise_path(exercise, as: user)
      page.click_on I18n.t('exercises.show.start_exercise')
    end

    def upload_public_key(key_text = 'ssh-rsa 123')
      page.fill_in(
        I18n.t('simple_form.labels.gitolite_public_key.data'),
        with: key_text
      )
      page.click_on I18n.t('helpers.submit.gitolite_public_key.create')
    end

    def set_username(username)
      page.fill_in(
        I18n.t('simple_form.labels.user.username'),
        with: username
      )
      page.click_on I18n.t('helpers.submit.username.update')
    end

    def submit_solution(filename = 'example.txt')
      create(:clone, user: user, exercise: exercise)
      create_public_key
      page.visit exercise_path(exercise, as: user)
      push_to_clone(filename)
      page.click_on I18n.t('exercises.show.submit_solution')
    end

    def push_to_clone(filename)
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

    def comment_on_solution(comment = 'Looks good')
      page.within('.comment-form') do
        page.fill_in 'comment_text', with: comment
        page.click_on I18n.t('comments.form.submit')
      end
    end

    def comment_on_solution_inline(comment = 'Looks great')
      expand_inline_comment_form

      page.within '.line-comments' do
        page.fill_in 'comment_text', with: comment
        page.click_on I18n.t('comments.form.submit')
      end
    end

    def click_continue
      page.click_link I18n.t('solutions.show.continue')
    end

    def create_solution_by_other_user(options = {})
      diff = generate_diff(options[:filename] || 'otherfile.txt')
      user = options[:user] ||
               create(:user, username: options[:username] || 'otheruser')
      clone = create(:clone, user: user, exercise: exercise)
      create(:solution, clone: clone).tap do |solution|
        create(:revision, diff: diff, solution: solution)
      end
    end

    def create_completed_solution(user)
      clone = create(:clone, user: user, exercise: exercise)
      create(:solution, clone: clone).tap do |solution|
        create(:revision, solution: solution)
      end
    end

    def request_clone_help
      page.click_on I18n.t('exercises.show.clone_help')
    end

    private

    attr_reader :exercise, :page, :user

    def create_public_key(data: 'ssh-rsa 123')
      @user.public_keys.create!(data: data, fingerprint: 'stubbed')
    end

    def stub_diff_command(filename)
      Gitolite::FakeShell.with_stubs do |stubs|
        ShellStubber.new(stubs).
          diff(generate_diff(filename))

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
      Capybara.using_driver :rack_test do
        Capybara.using_session 'api_client' do
          yield Capybara.current_session.driver
        end
      end
    end

    def expand_inline_comment_form
      element = page.first('div.comments')
      element.hover
      page.within element do
        page.find('a').click
      end
    end
  end

  def start_exercise_workflow(*args)
    ExerciseWorkflow.new(page, *args)
  end
end
