require "test_helper"

class ClearTest < Minitest::Test
  let(:settings) { Redis::Settings.new("app") }
  let(:redis) { Redis::Settings.connection }

  test "removes all settings" do
    settings[:items] = 5

    refute redis.hgetall(settings.namespace).empty?
    settings.clear
    assert redis.hgetall(settings.namespace).empty?
  end
end
