require "spec_helper"

describe UpcaseClient do
  COMMON_ERRORS = [
    *HTTP_ERRORS,
    OAuth2::Error.new(OAuth2::Response.new(Faraday::Response.new))
  ]

  describe ".update_state" do
    COMMON_ERRORS.each do |error|
      it "notifies airbrake of trapped #{error}" do
        error_notifier = double("error_notifier", notify: nil)
        token = double
        token.stub(:post).and_raise(error)
        client = double(request: nil)
        OAuth2::AccessToken.stub(:new).and_return(token)
        upcase_client = build_upcase_client(
          client: client,
          error_notifier: error_notifier
        )

        upcase_client.update_status(
          double(auth_token: "token"),
          "exercise",
          "state"
        )

        expect(error_notifier).to have_received(:notify)
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
      upcase_client = build_upcase_client(client: oauth_upcase_client)

      response = upcase_client.synchronize_exercise(attributes)
      expect(response.status).to eq 200

      json_response = JSON.parse(response.body)
      expect(json_response["title"]).to eq attributes[:title]
      expect(json_response["url"]).to eq attributes[:url]
      expect(json_response["summary"]).to eq attributes[:summary]
      expect(json_response["uuid"]).to eq attributes[:uuid]
    end

    context "with invalid attributes" do
      it "notifies error service" do
        error_notifier = double("error_notifier", notify: nil)
        upcase_client = build_upcase_client(
          client: oauth_upcase_client,
          error_notifier: error_notifier
        )

        upcase_client.synchronize_exercise(uuid: "UUID", title: "")

        expect(error_notifier).to have_received(:notify)
      end
    end

    context "with other errors" do
      COMMON_ERRORS.each do |error|
        it "notifies airbrake of trapped #{error}" do
          attributes = {
            title: "Refactoring",
            url: "https://exercise.upcase.com/exercises/refactoring",
            summary: "Just make the code looks better!",
            uuid: "UUID"
          }
          error_notifier = double("error_notifier", notify: nil)
          client_credentials = client_credentials_fail_with(error)
          upcase_client = build_upcase_client(
            client: double(client_credentials: client_credentials),
            error_notifier: error_notifier
          )

          upcase_client.synchronize_exercise(attributes)

          expect(error_notifier).to have_received(:notify)
        end
      end
    end
  end

  def build_upcase_client(
    client:,
    error_notifier: double("error_notifier", notify: nil)
  )
    UpcaseClient.new(client, error_notifier: error_notifier)
  end

  def client_credentials_fail_with(error)
    token = double
    token.stub(:put).and_raise(error)
    double(get_token: token)
  end
end
