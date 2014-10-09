require "spec_helper"

describe UpcaseClient do
  describe ".update_state" do
    [
      *HTTP_ERRORS,
      OAuth2::Error.new(OAuth2::Response.new(Faraday::Response.new))
    ].each do |error|
      it "notifies airbrake of trapped #{error}" do
        token = double
        token.stub(:post).and_raise(error)
        client = double(request: nil)
        OAuth2::AccessToken.stub(:new).and_return(token)
        Airbrake.stub(:notify)

        expect do
          UpcaseClient.new(client).update_status(
            double(auth_token: "token"),
            "exercise",
            "state"
          )
        end.not_to raise_exception
        expect(Airbrake).to have_received(:notify)
      end
    end
  end
end
