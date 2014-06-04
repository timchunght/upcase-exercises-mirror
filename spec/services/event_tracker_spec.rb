require 'spec_helper'

describe EventTracker do
  describe '#track_solution_submission' do
    it 'tracks solution submission' do
      user = double('user', id: 1)
      exercise = double('exercise', title: 'Awesome Exercise')
      analytics_backend = double('analytics_backend')
      analytics_backend.stub(:track)
      tracker = EventTracker.new(analytics_backend)

      tracker.track_solution_submission(user, exercise)

      expected_options = {
        user_id: user.id,
        event: 'Submitted Solution',
        properties: { exercise: exercise.title },
        integrations: { all: false, KISSmetrics: true }
      }
      expect(analytics_backend).to have_received(:track).with(expected_options)
    end
  end
end
