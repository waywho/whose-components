# frozen_string_literal: true

class Whose::Form::FieldComponent < ViewComponent::Base
  CLASSES = {
    input: "block w-full rounded-box border border-border bg-surface px-3 py-2 text-fg font-sans " \
           "placeholder:text-muted aria-invalid:border-negative " \
           "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent",
    textarea: "min-h-24 field-sizing-content",
    file: "file:mr-3 file:rounded-box file:border-0 file:bg-accent-soft file:px-3 file:py-1 file:text-accent-text",
    check: "size-4 rounded-box border border-border accent-accent " \
           "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent",
    color: "h-10 cursor-pointer p-1!",
    radio: "size-4 rounded-full border border-border accent-accent " \
           "focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent",
    toggle: "h-5 w-9 shrink-0 cursor-pointer appearance-none rounded-full bg-border transition-colors checked:bg-accent " \
            "before:m-0.5 before:block before:size-4 before:rounded-full before:bg-surface before:transition-transform " \
            "checked:before:translate-x-4 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent",
    password_wrapper: "relative",
    password_input: "pr-16",
    password_hidden: "hidden",
    password_button: "absolute inset-y-0 right-0 px-3 text-sm text-accent-text cursor-pointer"
  }.freeze
  WRAPPER_CLASSES = {
    vertical: "flex flex-col gap-1",
    horizontal: "flex flex-col gap-1 sm:grid sm:grid-cols-[12rem_1fr] sm:gap-x-4",
    inline: "flex flex-col gap-1 sm:flex-1"
  }.freeze
  LABEL_CLASSES = {
    vertical: "text-sm font-medium text-fg",
    horizontal: "text-sm font-medium text-fg sm:pt-2",
    inline: "text-sm font-medium text-fg"
  }.freeze

  def initialize(form:, method:, label:, hint:, layout:, inline: false, group: false, placeholder_label: false)
    @group = group
    @form = form
    @method = method
    @label = label
    @hint = hint
    @layout = layout
    @inline = inline
    @placeholder_label = placeholder_label
  end

  def placeholder_label?
    @placeholder_label
  end

  def label_text
    @label || @method.to_s.humanize
  end

  def error_message
    @form.object&.errors&.[](@method)&.first
  end

  def error_id
    "#{@form.object_name}_#{@method}_error"
  end

  def hint_id
    "#{@form.object_name}_#{@method}_hint"
  end

  def label_id
    "#{@form.object_name}_#{@method}_label"
  end

  def aria(caller_aria = {})
    describedby = [ caller_aria[:describedby], (hint_id if @hint), (error_id if error_message) ].compact.join(" ")
    caller_aria.merge(invalid: (true if error_message), describedby: describedby.presence).compact
  end

  def wrapper_attributes
    attributes = { class: wrapper_classes, data: { field: true, layout: @layout } }
    @group ? attributes.merge(role: "group", aria: { labelledby: label_id }) : attributes
  end

  def wrapper_classes
    placeholder_label? && @layout == :horizontal ? WRAPPER_CLASSES[:vertical] : WRAPPER_CLASSES[@layout]
  end

  def label_classes
    placeholder_label? ? "sr-only" : LABEL_CLASSES[@layout]
  end
end
