require "spec_helper"

feature "RSS feed" do
  scenario "returns a feed of the latest solutions" do
    users = [
      create(:user, username: "wendy"),
      create(:user, username: "billy")
    ]
    exercise = create(:exercise, title: "Make the donuts")
    workflow = start_exercise_workflow(exercise: exercise)
    users.each { |user| workflow.create_solution_by_other_user(user: user) }

    page.driver.get(
      "/api/solutions.rss",
      nil,
      "HTTP_AUTHORIZATION" =>
      ActionController::HttpAuthentication::Basic.encode_credentials(
        ENV["API_USERNAME"],
        ENV["API_PASSWORD"]
      )
    )

    expect(page).to have_xpath("//rss[@version='2.0']")
    expect(page).to have_xpath(
      "//rss/channel/title",
      text: "Latest Solutions To Upcase Exercises"
    )
    expect(page).to have_xpath(
      "//rss/channel/item/title",
      text: "Solution to Make the donuts by wendy"
    )
    expect(page).to have_xpath(
      "//rss/channel/item/title",
      text: "Solution to Make the donuts by billy"
    )
  end
end
