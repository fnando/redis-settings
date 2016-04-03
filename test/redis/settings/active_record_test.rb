require "test_helper"

class ActiveRecordTest < Minitest::Test
  let(:user) { User.create! }
  let(:admin) { Admin::User.create! }
  let(:root) { Redis::Settings.root_namespace }

  setup do
    user
    admin
    root
  end

  test "injects settings method" do
    assert User.new.respond_to?(:settings)
  end

  test "raises when trying to access settings from a new record" do
    assert_raises(Redis::Settings::NewRecordError) { User.new.settings }
  end

  test "doesn't raise exception if new record was destroyed" do
    User.new { |u| u.id = 7 }.destroy
  end

  test "sets namespace accordingly" do
    assert_equal user.settings.namespace, "#{root}/user/#{user.id}"
    assert_equal admin.settings.namespace, "#{root}/admin/user/#{admin.id}"
  end

  test "defines setting" do
    admin.settings[:role] = "admin"
    user.settings[:role] = "support"

    assert_equal user.settings[:role], "support"
    assert_equal admin.settings[:role], "admin"
  end

  test "removes all settings when destroy a record" do
    user.settings[:role] = "customer"
    user.destroy
    settings = Redis::Settings.connection.hgetall("#{root}/user/#{user.id}")

    assert settings.empty?
  end
end
