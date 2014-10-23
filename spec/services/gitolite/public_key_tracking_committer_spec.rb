require "spec_helper"

describe Gitolite::PublicKeyTrackingCommitter do
  describe "#write" do
    it "delegates and clears pending keys" do
      message = double("message")
      committer = double("committer")
      committer.stub(:write)
      public_keys = double("public_keys")
      public_keys.stub(:clear_pending).and_yield
      tracking_committer =
        Gitolite::PublicKeyTrackingCommitter.new(committer, public_keys: public_keys)

      tracking_committer.write(message)

      expect(committer).to have_received(:write).with(message)
      expect(public_keys).to have_received(:clear_pending)
    end
  end
end
