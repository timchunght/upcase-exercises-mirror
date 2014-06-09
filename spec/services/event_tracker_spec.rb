require 'spec_helper'

describe EventTracker do
  describe '#track_solution_submission' do
    it 'tracks solution submission' do
      user = double('user', learn_uid: 1)
      exercise = double('exercise', title: 'An Exercise', slug: 'an-exercise')
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
      exercise = double('exercise', title: 'An Exercise', slug: 'an-exercise')
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
      exercise = double('exercise', title: 'An Exercise', slug: 'an-exercise')
      tracker = EventTracker.new(user, exercise, analytics_backend)

      tracker.track_revision_submission

      expect(analytics_backend).
        to have_received(:track).
        with(expected_options('Submitted Revision', user, exercise))
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
