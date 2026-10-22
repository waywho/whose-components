# frozen_string_literal: true

module Whose::Authenticatable
  extend ActiveSupport::Concern

  included do
    has_secure_password
    has_many :sessions, class_name: "Whose::Session", dependent: :destroy

    normalizes :email_address, with: -> { it.strip.downcase }
    normalizes :first_name, :last_name, with: -> { it.strip.presence }

    validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 8 }, allow_nil: true
    validates :first_name, presence: true

    before_save { self.name = [ first_name, last_name ].compact_blank.join(" ") }

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
