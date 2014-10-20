require "spec_helper"

describe UpcaseClient do
  COMMON_ERRORS = [
    *HTTP_ERRORS,
    OAuth2::Error.new(OAuth2::Response.new(Faraday::Response.new))
  ]

  describe ".update_state" do
    COMMON_ERRORS.each do |error|
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

  describe "#synchronize_exercise" do
    let(:oauth_upcase_client) do
      OAuth2::Client.new(
        ENV["UPCASE_CLIENT_ID"],
        ENV["UPCASE_CLIENT_SECRET"],
        site: ENV["UPCASE_URL"]
      )
    end

    it "sends data with correct attributes" do
      attributes = {
        title: "Refactoring",
        url: "https://exercise.upcase.com/exercises/refactoring",
        summary: "Just make the code looks better!",
        uuid: "UUID"
      }
      upcase_client = UpcaseClient.new(oauth_upcase_client)

      response = upcase_client.synchronize_exercise(attributes)
      expect(response.status).to eq 200

      json_response = JSON.parse(response.body)
      expect(json_response["title"]).to eq attributes[:title]
      expect(json_response["url"]).to eq attributes[:url]
      expect(json_response["summary"]).to eq attributes[:summary]
      expect(json_response["uuid"]).to eq attributes[:uuid]
    end

    context "with invalid attributes" do
      it "notifies airbrake" do
        Airbrake.stub(:notify)
        upcase_client = UpcaseClient.new(oauth_upcase_client)

        expect do
          upcase_client.synchronize_exercise(uuid: "UUID", title: "")
        end.not_to raise_exception

        expect(Airbrake).to have_received(:notify)
      end
    end

    context "with other errors" do
      COMMON_ERRORS.each do |error|
        it "notifies airbrake of trapped #{error}" do
          token = double
          token.stub(:put).and_raise(error)
          client = double(client_credentials: double(get_token: token))
          Airbrake.stub(:notify)
          attributes = {
            title: "Refactoring",
            url: "https://exercise.upcase.com/exercises/refactoring",
            summary: "Just make the code looks better!",
            uuid: "UUID"
          }

          expect do
            UpcaseClient.new(client).synchronize_exercise(attributes)
          end.not_to raise_exception
          expect(Airbrake).to have_received(:notify)
        end
      end
    end
  end
end
