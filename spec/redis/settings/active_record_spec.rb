require "spec_helper"

describe Redis::Settings::ActiveRecord do
  let!(:user) { User.create! }
  let!(:admin) { Admin::User.create! }
  let!(:root) { Redis::Settings.root_namespace }

  it "injects settings method" do
    User.new.should respond_to(:settings)
  end

  it "raises when trying to access settings from a new record" do
    expect {
      User.new.settings
    }.to raise_error(Redis::Settings::NewRecordError)
  end

  it "doesn't raise exception if new record was destroyed" do
    expect {
      User.new { |u| u.id = 7 }.destroy
    }.to_not raise_error(Redis::Settings::NewRecordError)
  end

  it "sets namespace accordingly" do
    user.settings.namespace.should == "#{root}/user/#{user.id}"
    admin.settings.namespace.should == "#{root}/admin/user/#{admin.id}"
  end

  it "defines setting" do
    admin.settings[:role] = "admin"
    user.settings[:role] = "support"

    user.settings[:role].should == "support"
    admin.settings[:role].should == "admin"
  end

  it "removes all settings when destroy a record" do
    user.settings[:role] = "customer"
    user.destroy
    settings = Redis::Settings.connection.hgetall("#{root}/user/#{user.id}")
    expect(settings).to be_empty
  end
end
