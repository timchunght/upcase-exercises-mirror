require "spec_helper"

describe CommentNotifier do
  describe "#comment_created" do
    it "delivers a new comment notification" do
      comment = double("comment")
      notification = double("notification")
      notification.stub(:deliver)
      notification_factory = double("factory")
      notification_factory.
        stub("new").
        with(comment: comment).
        and_return(notification)
      comment_notifier = CommentNotifier.new(notification_factory)

      comment_notifier.comment_created(comment)

      expect(notification).to have_received(:deliver)
    end
  end
end
