class Gitolite::PublicKeysController < ApplicationController
  def create
    @public_key = create_public_key
    add_public_key_to_gitolite
    redirect_to :back, notice: I18n.t('gitolite.public_keys.create.notice')
  end

  private

  def create_public_key
    dependencies[:current_public_keys].create!(data: public_key_data)
  end

  def add_public_key_to_gitolite
    dependencies[:git_server].add_key(current_user.username)
  end

  def public_key_data
    public_key_attributes[:data]
  end

  def public_key_attributes
    params.require(:gitolite_public_key).permit(:data)
  end
end
