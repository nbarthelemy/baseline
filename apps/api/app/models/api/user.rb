module Api
  class User < ::Core::User

    # May also include :destroy if you need callbacks
    has_many :access_grants, class_name: "Doorkeeper::AccessGrant",
      foreign_key: :resource_owner_id, dependent: :delete_all

    # May also include :destroy if you need callbacks
    has_many :access_tokens, class_name: "Doorkeeper::AccessToken",
      foreign_key: :resource_owner_id, dependent: :delete_all

  end
end