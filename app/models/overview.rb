# Facade to encapsulate data for exercise overview and instructions page.
class Overview
  pattr_initialize [:exercise!, :participation!, :user!]
  attr_reader :exercise
  delegate :title, to: :exercise
  delegate :has_clone?, :unpushed?, to: :participation

  def clone
    participation.find_clone
  end

  def has_public_key?
    user.public_keys.any?
  end
end
