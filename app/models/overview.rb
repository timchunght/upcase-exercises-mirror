# Facade to encapsulate data for exercise overview and instructions page.
class Overview
  pattr_initialize [:channel!, :exercise!, :participation!, :revision!, :user!]
  attr_reader :exercise
  delegate :name, to: :channel, prefix: true
  delegate :title, to: :exercise
  delegate :has_clone?, :unpushed?, to: :participation
  delegate :files, to: :revision
  delegate :has_pending_public_keys?, :username?, to: :user

  def clone
    participation.find_clone
  end

  def has_public_key?
    user.public_keys.any?
  end
end
