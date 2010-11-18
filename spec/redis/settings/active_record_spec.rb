require "spec_helper"

describe Redis::Settings::ActiveRecord do
  let(:user) { User.create }
  let(:admin) { Admin::User.create }

  before do
    user.settings.clear
    admin.settings.clear
  end

  it "should inject settings method" do
    User.new.should respond_to(:settings)
  end

  it "should raise when trying to access settings from a new record" do
    expect {
      User.new.settings
    }.to raise_error(Redis::Settings::NewRecordError)
  end

  it "should set namespace accordingly" do
    user.settings.namespace.should == "settings/user/#{user.id}"
    admin.settings.namespace.should == "settings/admin/user/#{admin.id}"
  end

  it "should define setting" do
    admin.settings[:role] = "admin"
    user.settings[:role] = "support"

    user.settings[:role].should == "support"
    admin.settings[:role].should == "admin"
  end

  it "should remove all settings when destroy a record" do
    user.settings[:role] = "customer"
    user.destroy
    Redis::Settings.connection.hgetall("settings/user/#{user.id}").should be_empty
  end
end
