module App
  class User < ::Core::User

    # Include default devise modules. Others available are:
    # :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable,
      :confirmable, :lockable

  end
end