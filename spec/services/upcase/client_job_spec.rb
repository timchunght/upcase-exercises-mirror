require "spec_helper"

describe Upcase::ClientJob do
  describe "#perform" do
    it "calls the correct method on the Upcase server" do
      upcase_client = double("upcase_client")
      allow(upcase_client).to receive(:expected_method)
      stub_dependencies immediate_upcase_client: upcase_client
      args = %w(one two)
      job = Upcase::ClientJob.new(method_name: "expected_method", data: args)

      job.perform

      expect(upcase_client).to have_received(:expected_method).with(*args)
    end
  end

  describe "#error" do
    it "sends notifications" do
      error = StandardError.new("oops")
      error_notifier = double("error_notifier")
      allow(error_notifier).to receive(:notify)
      stub_dependencies error_notifier: error_notifier
      job = Upcase::ClientJob.new(method_name: "expected_method", data: [])

      job.error(job, error)

      expect(error_notifier).to have_received(:notify).with(error)
    end
  end

  def stub_dependencies(dependencies)
    allow(Payload::RailsLoader).to receive(:load).and_return(dependencies)
  end
end
