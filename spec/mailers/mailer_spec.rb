require 'spec_helper'

describe Mailer do
  describe '#comment' do
    it 'notifies the recipient about a new comment on their solution' do
      exercise = build_stubbed(:exercise)
      author = build_stubbed(:user)
      recipient = build_stubbed(:user)
      submitter = build_stubbed(:user)
      comment = build_stubbed(:comment)

      message = Mailer.comment(
        author: author,
        comment: comment,
        exercise: exercise,
        recipient: recipient,
        submitter: submitter,
      )

      expect(message).to have_subject(
        I18n.t('mailer.comment.subject', exercise: exercise.title)
      )
      expect(message).to deliver_to(recipient.email)
      expect(message).to deliver_from(Mailer::FROM)
      expect(message).to have_body_text(author.username)
      expect(message).to have_body_text(comment.text)
      expect(message).
        to have_body_text(exercise_solution_url(exercise, submitter))
    end
  end
end
