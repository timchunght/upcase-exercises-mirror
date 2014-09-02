require "spec_helper"

describe Api::PushesController do
  describe "#create" do
    context "with an unknown solution" do
      it "returns an empty 404" do
        participation = double("participation")
        participation.
          stub(:push_to_clone).
          and_raise(ActiveRecord::RecordNotFound)

        push_solution_for participation

        expect(controller).to respond_with(404)
        expect(response.body.strip).to be_empty
      end
    end

    context "with an existing solution" do
      it "triggers an update" do
        participation = double("participation")
        participation.stub(:push_to_clone)

        push_solution_for participation

        expect(controller).to respond_with(201)
        expect(participation).to have_received(:push_to_clone)
      end
    end

    context "with invalid authentication" do
      it "responds with not authorized" do
        participation = double("participation")
        participation.stub(:push_to_clone)

        push_solution_for participation, password: "not#{ENV["API_PASSWORD"]}"

        expect(controller).to respond_with(401)
        expect(participation).not_to have_received(:push_to_clone)
      end
    end
  end

  def push_solution_for(participation, password: ENV["API_PASSWORD"])
    exercise = build_stubbed(:exercise)
    Exercise.stub(:find).with(exercise.to_param).and_return(exercise)
    user = build_stubbed(:user)
    User.stub(:find).with(user.to_param).and_return(user)
    factory = stub_factory(:participation_factory)
    factory.
      stub(:new).
      with(exercise: exercise, user: user).
      and_return(participation)
    authenticate ENV["API_USERNAME"], password
    post :create, exercise_id: exercise.to_param, user_id: user.to_param
  end

  def authenticate(username, password)
    request.env["HTTP_AUTHORIZATION"] =
      ActionController::HttpAuthentication::Basic.encode_credentials(
        username,
        password
      )
  end
end
