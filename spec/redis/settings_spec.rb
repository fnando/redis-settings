require "spec_helper"

describe Redis::Settings do
  subject(:settings) { Redis::Settings.new("app") }
  let(:redis) { Redis::Settings.connection }

  before do
    settings.clear
  end

  describe "#all" do
    it "returns all settings" do
      settings[:items] = 10
      settings[:enabled] = true

      expect(settings.all).to eq(:items => 10, :enabled => true)
    end
  end

  describe ".configure" do
    it "yields module" do
      expect {|block|
        Redis::Settings.configure(&block)
      }.to yield_with_args(Redis::Settings)
    end
  end

  describe ".root_namespace" do
    before { Redis::Settings.root_namespace = "settings/development" }
    after { Redis::Settings.root_namespace = "settings" }

    it "uses custom namespace" do
      expect(settings.namespace).to eq("settings/development/app")
    end

    it "sets value using custom namespace" do
      settings[:items] = 10
      payload = JSON.parse(
        redis.hget("settings/development/app", :items)
      )

      expect(payload).to eq("data" => 10)
    end
  end

  describe "#namespace" do
    it "includes settings as namespace root" do
      expect(settings.namespace).to eq("settings/app")
    end
  end

  describe "#set" do
    it "sets value" do
      settings.set(:items, 5)
      payload = JSON.parse(
        redis.hget(settings.namespace, :items)
      )

      expect(payload).to eq("data" => 5)
    end

    it "has shortcut" do
      settings[:items] = 10
      payload = JSON.parse(
        redis.hget(settings.namespace, :items)
      )

      expect(payload).to eq("data" => 10)
    end

    it "removes setting when assigning nil" do
      settings[:items] = 20
      settings[:items] = nil

      expect(redis.hget(settings.namespace, :items)).to be_nil
    end
  end

  describe "#remove" do
    it "removes option" do
      settings[:items] = 20
      settings.remove(:items)

      expect(redis.hget(settings.namespace, :items)).to be_nil
    end

    it "has alias" do
      settings[:items] = 20
      settings.delete(:items)

      expect(redis.hget(settings.namespace, :items)).to be_nil
    end
  end

  describe "#get" do
    it "gets value" do
      settings.set(:items, 5)
      expect(settings.get(:items)).to eq(5)
    end

    it "has #[] alias" do
      settings[:items] = 10
      expect(settings[:items]).to eq(10)
    end

    it "has #fetch alias" do
      settings[:items] = 10
      expect(settings.fetch(:items)).to eq(10)
    end

    it "returns default value" do
      settings[:items] = nil
      expect(settings.get(:items, 15)).to eq(15)
    end

    it "returns false as default value" do
      settings[:item] = false
      expect(settings.get(:item, true)).to eq(false)
    end
  end

  describe "#clear" do
    it "removes all settings" do
      settings[:items] = 5

      expect(redis.hgetall(settings.namespace)).not_to be_empty
      settings.clear
      expect(redis.hgetall(settings.namespace)).to be_empty
    end
  end
end
