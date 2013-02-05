class User < ActiveRecord::Base
end

module Admin
  class User < ActiveRecord::Base
    self.table_name = "users"
  end
end
