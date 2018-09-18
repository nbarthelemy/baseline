module Core
  class User < Core::ApplicationRecord
    self.table_name = 'users'

    # Include default devise modules.
    # Others available are: :timeoutable
    devise :database_authenticatable, :registerable, :validatable, :confirmable, :lockable,
      :recoverable, :rememberable, :trackable, :omniauthable, :doorkeeper, :async

    # handle name formatting
    has_person_name

  end
end