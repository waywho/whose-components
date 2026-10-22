# frozen_string_literal: true

class Whose::Form::FieldComponentPreview < ViewComponent::Preview
  class Account
    include ActiveModel::Model

    attr_accessor :name, :email, :password, :bio, :role, :newsletter, :notifications, :avatar
  end

  def vertical
    render_with_template(template: "whose/form/field_component_preview/form", locals: { account: invalid_account, layout: :vertical })
  end

  def horizontal
    render_with_template(template: "whose/form/field_component_preview/form", locals: { account: invalid_account, layout: :horizontal })
  end

  private

  def invalid_account
    Account.new(email: "not-an-email").tap do |account|
      account.errors.add(:name, "can't be blank")
      account.errors.add(:email, "is invalid")
    end
  end
end
