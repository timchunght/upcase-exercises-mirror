require 'spec_helper'

describe DelayedMailer do
  describe '#deliver' do
    it 'creates a background job for the mailer' do
      delay_chain = double('delay_chain')
      delay_chain.stub(:example)
      mailer = double('mailer')
      mailer.stub(:example)
      mailer.stub(:delay).and_return(delay_chain)
      delayed_mailer = DelayedMailer.new(mailer)

      delayed_mailer.example.deliver

      expect(delay_chain).to have_received(:example)
    end
  end
end
