require "spec_helper"

describe StatusUpdater do
  let(:upcase_client) do
    upcase_client = double("upcase_client")
    upcase_client.stub(:update_status)
    upcase_client
  end

  def self.it_updates_remote_status(opts)
    it "##{opts[:when]} updates the remote status with #{opts[:to]}" do
      exercise = double("exercise", uuid: "exercise-uuid")
      status_updater = StatusUpdater.new(
        user: create(:user),
        exercise: exercise,
        upcase_client: upcase_client
      )

      status_updater.send(opts[:when])

      expect(upcase_client).
        to have_received(:update_status).with(exercise.uuid, opts[:to])
    end
  end

  it_updates_remote_status to: "Started", when: :clone_created
  it_updates_remote_status to: "Submitted", when: :solution_submitted
  it_updates_remote_status to: "Pushed", when: :revision_submitted
  it_updates_remote_status to: "Reviewed", when: :comment_created
end
