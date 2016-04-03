require "test_helper"

class NamespaceTest < Minitest::Test
  let(:settings) { Redis::Settings.new("app") }

  test "includes settings as namespace root" do
    assert_equal "settings/app", settings.namespace
  end
end
