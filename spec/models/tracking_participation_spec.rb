require 'spec_helper'

describe TrackingParticipation do
  it 'delegates to participation' do
    participation = double('participation', some_method: nil)
    tracking_participation = TrackingParticipation.new(participation, double)

    tracking_participation.some_method

    expect(participation).to have_received(:some_method)
  end

  it 'tracks clone creation when a clone is created' do
    participation = double('participation', create_clone: nil)
    event_tracker = double('event_tracker', track_clone_creation: nil)
    tracking_participation =
      TrackingParticipation.new(participation, event_tracker)

    tracking_participation.create_clone

    expect(event_tracker).to have_received(:track_clone_creation)
  end

  it 'tracks solution submission when a solution is created' do
    participation = double('participation', find_or_create_solution: nil)
    event_tracker = double('event_tracker', track_solution_submission: nil)
    tracking_participation =
      TrackingParticipation.new(participation, event_tracker)

    tracking_participation.find_or_create_solution

    expect(event_tracker).to have_received(:track_solution_submission)
  end
end
