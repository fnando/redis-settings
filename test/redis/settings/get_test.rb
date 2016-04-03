require "test_helper"

class GetTest < Minitest::Test
  let(:settings) { Redis::Settings.new("app") }

  test "gets value" do
    settings.set(:items, 5)
    assert_equal 5, settings.get(:items)
  end

  test "has #[] alias" do
    settings[:items] = 10
    assert_equal 10, settings[:items]
  end

  test "has #fetch alias" do
    settings[:items] = 10
    assert_equal 10, settings.fetch(:items)
  end

  test "returns default value" do
    settings[:items] = nil
    assert_equal 15, settings.get(:items, 15)
  end

  test "returns false as default value" do
    settings[:item] = false
    assert_equal false, settings.get(:item, true)
  end
end
