# frozen_string_literal: true

module Whose::ComponentHelper
  def button_component(*, **, &) = render(Whose::ButtonComponent.new(*, **), &)
  def link_component(*, **, &) = render(Whose::LinkComponent.new(*, **), &)
  def badge_component(*, **, &) = render(Whose::BadgeComponent.new(*, **), &)
  def card_component(*, **, &) = render(Whose::CardComponent.new(*, **), &)
  def flash_component(*, **, &) = render(Whose::FlashComponent.new(*, **), &)
  def page_header_component(*, **, &) = render(Whose::PageHeaderComponent.new(*, **), &)
  def list_component(*, **, &) = render(Whose::ListComponent.new(*, **), &)
  def list_row_component(*, **, &) = render(Whose::ListRowComponent.new(*, **), &)
  def modal_component(*, **, &) = render(Whose::ModalComponent.new(*, **), &)
  def offcanvas_component(*, **, &) = render(Whose::OffcanvasComponent.new(*, **), &)
  def tooltip_component(*, **, &) = render(Whose::TooltipComponent.new(*, **), &)
  def nav_component(*, **, &) = render(Whose::NavComponent.new(*, **), &)
  def nav_item_component(*, **, &) = render(Whose::Nav::ItemComponent.new(*, **), &)
  def pagination_component(*, **, &) = render(Whose::PaginationComponent.new(*, **), &)
end
