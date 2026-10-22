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

  test "sets name from first and last name before save" do
    user = create(:user, first_name: " Ann ", last_name: "Lee")

    assert_equal "Ann Lee", user.reload.name

    user.update!(last_name: "Kim")

    assert_equal "Ann Kim", user.reload.name
  end

  test "requires a first name" do
    assert_not build(:user, first_name: "").valid?
  end

  test "name is the first name alone when there is no last name" do
    user = create(:user, first_name: "Ann", last_name: " ").reload

    assert_equal "Ann", user.name
    assert_nil user.last_name
  end

  test "confirm sets confirmed at and ends the confirmation token" do
    user = create(:user, :unconfirmed)
    token = user.generate_token_for(:email_confirmation)
    assert_not user.confirmed?

    user.confirm!

    assert user.reload.confirmed?
    assert_nil User.find_by_token_for(:email_confirmation, token)
  end

  test "destroys its sessions" do
    user = create(:user)
    user.sessions.create!

    assert_difference("Whose::Session.count", -1) { user.destroy }
  end
end
