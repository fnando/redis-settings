require "spec_helper"

describe Redis::Settings do
  subject { Redis::Settings.new("app") }
  let(:redis) { Redis::Settings.connection }

  before do
    subject.clear
  end

  describe "#all" do
    it "returns all settings" do
      subject[:items] = 10
      subject[:enabled] = true

      subject.all.should == {:items => 10, :enabled => true}
    end
  end

  describe ".configure" do
    it "yields module" do
      Redis::Settings.configure {|config| config.should be(Redis::Settings)}
    end
  end

  describe ".root_namespace" do
    before { Redis::Settings.root_namespace = "settings/development" }
    after { Redis::Settings.root_namespace = "settings" }

    it "uses custom namespace" do
      subject.namespace.should == "settings/development/app"
    end

    it "sets value using custom namespace" do
      subject[:items] = 10
      JSON.parse(redis.hget("settings/development/app", :items)).should == {"data" => 10}
    end
  end

  describe "#namespace" do
    it "includes settings as namespace root" do
      subject.namespace.should == "settings/app"
    end
  end

  describe "#set" do
    it "sets value" do
      subject.set(:items, 5)
      JSON.parse(redis.hget(subject.namespace, :items)).should == {"data" => 5}
    end

    it "has shortcut" do
      subject[:items] = 10
      JSON.parse(redis.hget(subject.namespace, :items)).should == {"data" => 10}
    end

    it "removes setting when assigning nil" do
      subject[:items] = 20
      subject[:items] = nil
      redis.hget(subject.namespace, :items).should be_nil
    end
  end

  describe "#remove" do
    it "removes option" do
      subject[:items] = 20
      subject.remove(:items)
      redis.hget(subject.namespace, :items).should be_nil
    end

    it "has alias" do
      subject[:items] = 20
      subject.delete(:items)
      redis.hget(subject.namespace, :items).should be_nil
    end
  end

  describe "#get" do
    it "gets value" do
      subject.set(:items, 5)
      subject.get(:items).should == 5
    end

    it "has #[] alias" do
      subject[:items] = 10
      subject[:items].should == 10
    end

    it "has #fetch alias" do
      subject[:items] = 10
      subject.fetch(:items).should == 10
    end

    it "returns default value" do
      subject[:items] = nil
      subject.get(:items, 15).should == 15
    end
  end

  describe "#clear" do
    it "removes all settings" do
      subject[:items] = 5

      redis.hgetall(subject.namespace).should_not be_empty
      subject.clear
      redis.hgetall(subject.namespace).should be_empty
    end
  end
end
