module Sso
  class User < ::Core::User

    # Include default devise modules. Others available are:
    # :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable,
      :confirmable, :lockable, :doorkeeper

    # May also include :destroy if you need callbacks
    has_many :access_grants, class_name: "Doorkeeper::AccessGrant",
      foreign_key: :resource_owner_id, dependent: :delete_all

    # May also include :destroy if you need callbacks
    has_many :access_tokens, class_name: "Doorkeeper::AccessToken",
      foreign_key: :resource_owner_id, dependent: :delete_all

  end
end