# frozen_string_literal: true

class Whose::Session < ActiveRecord::Base
  self.table_name = "sessions"

  belongs_to :user
end
