module App
  class UserOnboarding
    include ActiveModel::Model

    attr_accessor :name, :email

    validates :name, presence: true
    validates_format_of :email, with: /\A([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})\z/i

  end
end