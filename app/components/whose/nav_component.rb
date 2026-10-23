# frozen_string_literal: true

class Whose::NavComponent < ViewComponent::Base
  BAR_STYLE = "flex items-center justify-between gap-4 border-border bg-surface font-sans text-fg"
  BOTTOM_HEIGHT = "h-[calc(3.5rem+env(safe-area-inset-bottom))]"
  ORIENTATION_STYLES = {
    horizontal: {
      root: "#{BAR_STYLE} w-full border-b px-4 py-3",
      list: "hidden flex-1 items-center gap-1 md:flex",
      actions: "hidden items-center gap-2 md:flex"
    },
    vertical: {
      root: "#{BAR_STYLE} w-full border-b px-4 py-3 md:h-dvh md:w-60 md:flex-col md:items-stretch md:justify-start md:border-r md:border-b-0 md:p-4",
      list: "hidden flex-col gap-1 md:flex",
      actions: "hidden items-center gap-2 md:mt-auto md:flex"
    },
    bottom: {
      root: "#{BAR_STYLE} #{BOTTOM_HEIGHT} fixed inset-x-0 bottom-0 z-10 border-t px-2 pb-[env(safe-area-inset-bottom)]",
      list: "flex flex-1 justify-center gap-4 [&_a]:flex-col [&_a]:gap-0.5 [&_a]:text-xs"
    }
  }.freeze

  renders_one :brand
  renders_one :actions
  renders_many :items, Whose::Nav::ItemComponent

  def initialize(orientation: :horizontal, **html_attributes)
    @html_attributes = html_attributes
    @orientation = orientation.to_sym
    raise ArgumentError, "Unknown orientation: #{orientation}. Use :horizontal, :vertical or :bottom." unless ORIENTATION_STYLES.key?(@orientation)
  end

  def attributes
    @html_attributes.merge(
      class: [ style[:root], @html_attributes[:class] ].compact,
      aria: { label: t(".main") }.merge(@html_attributes[:aria] || {})
    )
  end

  def spacer_style
    BOTTOM_HEIGHT
  end

  def spacer?
    @orientation == :bottom
  end

  def menu?
    @orientation != :bottom
  end

  def style
    ORIENTATION_STYLES.fetch(@orientation)
  end
end
