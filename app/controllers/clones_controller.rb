class ClonesController < ApplicationController
  def create
    clone = dependencies[:current_participation].find_or_create_clone
    redirect_to exercise_clone_url(clone.exercise)
  end

  def show
    ensure_current_user_has_public_keys do
      clone = dependencies[:current_participation].find_clone
      @clone = Git::Clone.new(
        clone,
        dependencies[:git_server]
      )
    end
  end

  private

  def ensure_current_user_has_public_keys
    if current_user.public_keys.any?
      yield
    else
      store_location
      redirect_to new_gitolite_public_key_url
    end
  end
end
