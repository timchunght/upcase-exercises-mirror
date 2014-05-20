class Mailer < ActionMailer::Base
  FROM = 'learn@thoughtbot.com'

  def comment(arguments = {})
    @author = arguments.fetch(:author)
    @comment = arguments.fetch(:comment)
    @exercise = arguments.fetch(:exercise)
    @recipient = arguments.fetch(:recipient)
    @submitter = arguments.fetch(:submitter)

    mail(
      from: FROM,
      subject: default_i18n_subject(exercise: @exercise.title),
      to: @recipient.email,
    )
  end
end
