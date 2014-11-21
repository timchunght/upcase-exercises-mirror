require "spec_helper"

describe BackgroundService do
  describe "#perform" do
    it "calls the correct method on the service" do
      service = double("service")
      allow(service).to receive(:expected_method)
      args = %w(one two)
      job = BackgroundService.new(
        service: service,
        method_name: "expected_method",
        data: args)

      job.perform

      expect(service).to have_received(:expected_method).with(*args)
    end
  end

  describe "#error" do
    it "sends notifications" do
      service = double("service")
      error = StandardError.new("oops")
      error_notifier = double("error_notifier")
      allow(error_notifier).to receive(:notify)
      stub_dependencies error_notifier: error_notifier
      job = BackgroundService.new(
        service: service,
        method_name: "expected_method",
        data: []
      )

      job.error(job, error)

      expect(error_notifier).to have_received(:notify).with(error)
    end
  end

  def stub_dependencies(dependencies)
    allow(Payload::RailsLoader).to receive(:load).and_return(dependencies)
  end
end
