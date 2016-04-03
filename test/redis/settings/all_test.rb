require "test_helper"

class AllTest < Minitest::Test
  let(:settings) { Redis::Settings.new("app") }

  test "returns all settings" do
    settings[:items] = 10
    settings[:enabled] = true

    expected = {items: 10, enabled: true}

    assert_equal expected, settings.all
  end
end
