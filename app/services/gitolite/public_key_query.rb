module Gitolite
  class PublicKeyQuery
    pattr_initialize :relation

    def for(user)
      by_user[user.id] || []
    end

    private

    def by_user
      @by_user ||= relation.group_by(&:user_id)
    end
  end
end
