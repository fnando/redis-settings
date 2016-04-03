require "test_helper"

class RemoveTest < Minitest::Test
  let(:settings) { Redis::Settings.new("app") }
  let(:redis) { Redis::Settings.connection }

  test "removes option" do
    settings[:items] = 20
    settings.remove(:items)

    assert_nil redis.hget(settings.namespace, :items)
  end

  test "has alias" do
    settings[:items] = 20
    settings.delete(:items)

    assert_nil redis.hget(settings.namespace, :items)
  end
end
