require 'spec_helper'

describe EventTracker do
  describe '#track_solution_submission' do
    it 'tracks solution submission' do
      user = double('user', learn_uid: 1)
      exercise = double('exercise', slug: 'an-exercise')
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.track_solution_submission

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options('Submitted Solution', user, exercise))
    end
  end

  describe '#track_clone_creation' do
    it 'tracks clone creation' do
      user = double('user', learn_uid: 1)
      exercise = double('exercise', slug: 'an-exercise')
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.track_clone_creation

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options('Started Exercise', user, exercise))
    end
  end

  describe '#track_revision_submission' do
    it 'tracks revision submission' do
      user = double('user', learn_uid: 1)
      exercise = double('exercise', slug: 'an-exercise')
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.track_revision_submission

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options('Submitted Revision', user, exercise))
    end
  end

  describe '#track_exercise_visit' do
    it 'tracks when a user visits an exercise' do
      user = double('user', learn_uid: 1)
      exercise = double('exercise', slug: 'an-exercise')
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.track_exercise_visit

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options('Visited Exercise', user, exercise))
    end
  end

  describe '#track_comment_creation' do
    it 'tracks user leaving comment and user receiving feedback' do
      user = double('user', learn_uid: 1)
      exercise = double('exercise', slug: 'an-exercise')
      other_user = double('other_user', learn_uid: 2)
      solution = double('solution', user: other_user)
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.track_comment_creation(solution)

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options('Left Comment', user, exercise))
      expect(analytics_backend).
        to have_received(:track).
        with(expected_options('Received Feedback', other_user, exercise))
    end
  end

  def analytics_backend
    @analytics_backend ||= begin
      analytics_backend = double('analytics_backend')
      analytics_backend.stub(:track)
      analytics_backend
    end
  end

  def expected_options(event_name, user, exercise)
    {
      user_id: user.learn_uid,
      event: event_name,
      properties: { exercise_slug: exercise.slug },
      integrations: { all: true }
    }
  end
end
