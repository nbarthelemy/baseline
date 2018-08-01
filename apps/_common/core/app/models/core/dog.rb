module Core
  class Dog < Core::ApplicationRecord
    self.table_name = 'users'
  end
end