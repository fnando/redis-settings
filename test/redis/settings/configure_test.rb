require "test_helper"

class ConfigureTest < Minitest::Test
  let(:settings) { Redis::Settings.new("app") }

  test "yields module" do
    config = nil

    Redis::Settings.configure {|c| config = c }

    assert_equal Redis::Settings, config
  end

  test "sets json parser" do
    assert_equal JSON, Redis::Settings.json_parser
  end
end
