# frozen_string_literal: true

require "test_helper"

class Whose::ErrorMessagesTest < ActiveSupport::TestCase
  {
    blank: [ {}, "Enter a value." ],
    taken: [ {}, "This value is already in use." ],
    invalid: [ {}, "Enter a valid value." ],
    too_short: [ { count: 8 }, "Use at least 8 characters." ],
    too_long: [ { count: 20 }, "Use at most 20 characters." ],
    confirmation: [ { attribute: "Password" }, "Enter the same value as Password." ],
    inclusion: [ {}, "Choose a value from the list." ],
    not_a_number: [ {}, "Enter a number." ],
    greater_than: [ { count: 3 }, "Enter a number greater than 3." ],
    less_than: [ { count: 9 }, "Enter a number less than 9." ]
  }.each do |key, (options, text)|
    test "#{key} message is plain English" do
      assert_equal text, I18n.t("errors.messages.#{key}", **options)
    end
  end

  test "too_short message in the singular keeps the count" do
    assert_equal "Use at least 1 character.", I18n.t("errors.messages.too_short", count: 1)
  end

  test "too_long message in the singular keeps the count" do
    assert_equal "Use at most 1 character.", I18n.t("errors.messages.too_long", count: 1)
  end
end
