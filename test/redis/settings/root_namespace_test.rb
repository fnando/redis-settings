require "test_helper"

class RootNamespaceTest < Minitest::Test
  let(:settings) { Redis::Settings.new("app") }
  let(:redis) { Redis::Settings.connection }

  setup { Redis::Settings.root_namespace = "settings/development" }
  teardown { Redis::Settings.root_namespace = "settings" }

  test "uses custom namespace" do
    assert_equal "settings/development/app", settings.namespace
  end

  test "sets value using custom namespace" do
    settings[:items] = 10
    payload = JSON.parse(
      redis.hget("settings/development/app", :items)
    )

    assert_equal Hash["data" => 10], payload
  end
end
