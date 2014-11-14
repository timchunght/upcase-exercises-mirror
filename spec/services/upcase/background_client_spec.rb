require 'spec_helper'

describe Upcase::BackgroundClient do
  %w(update_status synchronize_exercise).each do |method_name|
    describe "##{method_name}" do
      it 'creates a background job to delegate' do
        args = %w(one two)
        server = double('server')
        job_factory = double('job_factory')
        allow(job_factory).to receive(:new)
        background_server = Upcase::BackgroundClient.new(server, job_factory)

        result = background_server.send(method_name, *args)

        expect(result).to be_nil
        expect(job_factory).to have_received(:new).
          with(method_name: method_name, data: args)
      end
    end
  end
end
