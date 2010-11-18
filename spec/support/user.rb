class User < ActiveRecord::Base
end

module Admin
  class User < ActiveRecord::Base
    set_table_name "users"
  end
end
