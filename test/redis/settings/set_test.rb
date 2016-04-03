require "test_helper"

class SetTest < Minitest::Test
  let(:settings) { Redis::Settings.new("app") }
  let(:redis) { Redis::Settings.connection }

  test "sets value" do
    settings.set(:items, 5)
    payload = JSON.parse(
      redis.hget(settings.namespace, :items)
    )

    assert_equal Hash["data" => 5], payload
  end

  test "has shortcut" do
    settings[:items] = 10
    payload = JSON.parse(
      redis.hget(settings.namespace, :items)
    )

    assert_equal Hash["data" => 10], payload
  end

  test "removes setting when assigning nil" do
    settings[:items] = 20
    settings[:items] = nil

    assert_nil redis.hget(settings.namespace, :items)
  end
end
