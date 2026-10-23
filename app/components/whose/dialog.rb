# frozen_string_literal: true

module Whose::Dialog
  extend ActiveSupport::Concern

  included do
    renders_one :trigger
  end

  def title_id
    @title_id ||= "whose-dialog-title-#{SecureRandom.hex(4)}"
  end

  def attributes
    @html_attributes.merge(data: { controller: "whose-dialog", action: "click->whose-dialog#backdropClose" }.merge(@html_attributes[:data] || {}))
  end

  def before_render
    raise ArgumentError, "The trigger slot is required." unless trigger?
  end
end
