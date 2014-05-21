class Gitolite::PublicKeysController < ApplicationController
  def new
    @public_key = dependencies[:current_public_keys].new
  end

  def create
    @public_key = create_public_key
    redirect_back_or(root_url)
  end

  private

  def create_public_key
    dependencies[:current_public_keys].create!(data: public_key_data)
  end

  def public_key_data
    public_key_attributes[:data]
  end

  def public_key_attributes
    params.require(:gitolite_public_key).permit(:data)
  end
end
