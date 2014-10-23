require "spec_helper"

describe Gitolite::PublicKeyQuery do
  describe "#for" do
    it "returns the public keys for the given user" do
      user = create(:user)
      other_user = create(:user)
      create :public_key, user: user, data: "first"
      create :public_key, user: user, data: "second"
      create :public_key, user: other_user, data: "other"
      query = Gitolite::PublicKeyQuery.new(Gitolite::PublicKey.all)

      result = query.for(user)

      expect(result.map(&:data)).to match_array(%w(first second))
    end
  end
end
