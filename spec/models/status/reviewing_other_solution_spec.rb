require "spec_helper"

describe Status::ReviewingOtherSolution do
  describe "#applicable?" do
    context "when the reviewer has a solution and views another solution" do
      it "returns true" do
        review = double(
          "review",
          viewing_other_solution?: true,
          user_has_solution?: true
        )

        status = Status::ReviewingOtherSolution.new(review)

        expect(status).to be_applicable
      end
    end

    context "when viewing the submitted solution" do
      it "returns false" do
        review = double(
          "review",
          viewing_other_solution?: false,
          user_has_solution?: true
        )
        status = Status::ReviewingOtherSolution.new(review)

        expect(status).not_to be_applicable
      end
    end

    context "when the reviewer has no solution" do
      it "returns false" do
        review = double(
          "review",
          viewing_other_solution?: true,
          user_has_solution?: false
        )
        status = Status::ReviewingOtherSolution.new(review)

        expect(status).not_to be_applicable
      end
    end
  end

  describe "#to_partial_path" do
    it "returns a string" do
      status = Status::ReviewingOtherSolution.new(double("review"))
      result = status.to_partial_path

      expect(result).to eq("statuses/reviewing_solution")
    end
  end
end
