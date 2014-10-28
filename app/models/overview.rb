# Facade to encapsulate data for exercise overview and instructions page.
class Overview
  pattr_initialize [
    :channel!,
    :exercise!,
    :participation!,
    :progress!,
    :revision!,
    :solutions!,
    :status!,
    :user!
  ]
  attr_reader :exercise, :progress, :solutions, :status
  delegate :name, to: :channel, prefix: true
  delegate :title, to: :exercise
  delegate :has_clone?, :unpushed?, to: :participation
  delegate :files, to: :revision
  delegate :has_pending_public_keys?, :username?, to: :user

  def clone
    participation.find_clone
  end

  def has_pending_clone?
    clone.pending?
  end

  def has_public_key?
    user.public_keys.any?
  end
end
