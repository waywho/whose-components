# frozen_string_literal: true

require "test_helper"

class Whose::AuthenticatableTest < ActiveSupport::TestCase
  test "normalizes email address" do
    user = create(:user, email_address: " Ann@Example.COM ")

    assert_equal "ann@example.com", user.reload.email_address
    assert_equal user, User.authenticate_by(email_address: "ANN@example.com", password: "password123")
  end

  test "requires a unique email address" do
    create(:user, email_address: "ann@example.com")

    assert_not build(:user, email_address: "ANN@example.com").valid?
  end

  test "rejects an email address without the correct format" do
    assert_not build(:user, email_address: "ann").valid?
  end

  test "requires a password of at least 8 characters" do
    assert_not build(:user, password: "short").valid?
  end

  test "destroys its sessions" do
    user = create(:user)
    user.sessions.create!

    assert_difference("Whose::Session.count", -1) { user.destroy }
  end
end
