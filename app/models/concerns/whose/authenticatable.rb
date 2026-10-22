# frozen_string_literal: true

module Whose::Authenticatable
  extend ActiveSupport::Concern

  included do
    has_secure_password
    has_many :sessions, class_name: "Whose::Session", dependent: :destroy

    normalizes :email_address, with: -> { it.strip.downcase }

    validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 8 }, allow_nil: true

    generates_token_for :email_confirmation, expires_in: 2.days do
      confirmed_at
    end
  end

  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    update!(confirmed_at: Time.current)
  end
end
