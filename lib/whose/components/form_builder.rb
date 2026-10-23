# frozen_string_literal: true

require "action_view"

module Whose
  module Components
    class FormBuilder < ActionView::Helpers::FormBuilder
      delegate :render, :tag, :content_tag, :safe_join, :t, to: :@template

      %i[text_field email_field number_field telephone_field phone_field url_field date_field search_field
         datetime_field datetime_local_field time_field month_field week_field].each do |type|
        define_method(type) do |method, label: nil, hint: nil, **options|
          field(method, label:, hint:, placeholder: true) { |component| super(method, **input_options(component, options)) }
        end
      end

      def color_field(method, label: nil, hint: nil, **options)
        field(method, label:, hint:) { |component| super(method, **input_options(component, options, field_classes[:color])) }
      end

      def range_field(method, label: nil, hint: nil, **options)
        field(method, label:, hint:) { |component| super(method, **input_options(component, options)) }
      end

      def password_field(method, label: nil, hint: nil, **options)
        field(method, label:, hint:, placeholder: true) do |component|
          options[:data] = { whose_password_visibility_target: "input" }.merge(options[:data] || {})
          input = super(method, **input_options(component, options, field_classes[:password_input]))
          content_tag(:div, class: field_classes[:password_wrapper], data: { controller: "whose-password-visibility" }) do
            safe_join([ input, password_button ])
          end
        end
      end

      def textarea(method, label: nil, hint: nil, **options)
        field(method, label:, hint:, placeholder: true) do |component|
          super(method, **input_options(component, options, field_classes[:textarea]))
        end
      end
      alias_method :text_area, :textarea

      def file_field(method, label: nil, hint: nil, **options)
        field(method, label:, hint:) do |component|
          super(method, **input_options(component, options, field_classes[:file]))
        end
      end

      def select(method, choices = nil, options = {}, html_options = {}, &block)
        label, hint = options.values_at(:label, :hint)
        field(method, label:, hint:) do |component|
          super(method, choices, options.except(:label, :hint), input_options(component, html_options), &block)
        end
      end

      def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
        label, hint = options.values_at(:label, :hint)
        field(method, label:, hint:) do |component|
          super(method, collection, value_method, text_method, options.except(:label, :hint),
                input_options(component, html_options))
        end
      end

      def radio_button(method, tag_value, options = {})
        label, hint = options.values_at(:label, :hint)
        field(method, label: label || tag_value.to_s.humanize, hint:, inline: true, value: tag_value) do |component|
          super(method, tag_value, options.except(:label, :hint).merge(class: [ field_classes[:radio], options[:class] ].compact,
                                                                       aria: component.aria(options[:aria] || {})))
        end
      end

      def checkbox(method, options = {}, checked_value = "1", unchecked_value = "0")
        styled_checkbox(method, options, checked_value, unchecked_value, field_classes[:check])
      end
      alias_method :check_box, :checkbox

      def toggle(method, **options)
        styled_checkbox(method, options.merge(role: "switch"), "1", "0", field_classes[:toggle])
      end

      def submit(value = nil, **options)
        button = render(Whose::ButtonComponent.new(type: "submit", **options)) { value || submit_default_value }
        return button unless layout == :inline && labels == :visible

        tag.div(label_spacer + button, class: "flex flex-col gap-1")
      end

      private

      def label_spacer
        tag.span("&nbsp;".html_safe, class: "hidden text-sm font-medium sm:block", aria: { hidden: true })
      end

      def field_classes
        Whose::Form::FieldComponent::CLASSES
      end

      def layout
        @options[:layout] || :vertical
      end

      def labels
        @options[:labels] || :visible
      end

      def field(method, label:, hint:, inline: false, placeholder: false, value: nil, &block)
        component = Whose::Form::FieldComponent.new(form: self, method:, label:, hint:, layout:, inline:, value:,
                                                    placeholder_label: placeholder && labels == :placeholder)
        render(component) { block.call(component) }
      end

      def input_options(component, options, extra_class = nil)
        placeholder = component.placeholder_label? ? { placeholder: component.label_text } : {}
        placeholder.merge(options).merge(class: [ field_classes[:input], extra_class, options[:class] ].compact,
                                         aria: component.aria(options[:aria] || {}))
      end

      def styled_checkbox(attribute, options, checked_value, unchecked_value, css_class)
        label, hint = options.values_at(:label, :hint)
        field(attribute, label:, hint:, inline: true) do |component|
          checkbox_options = options.except(:label, :hint).merge(class: [ css_class, options[:class] ].compact,
                                                                 aria: component.aria(options[:aria] || {}))
          ActionView::Helpers::FormBuilder.instance_method(:checkbox)
                                          .bind_call(self, attribute, checkbox_options, checked_value, unchecked_value)
        end
      end

      def password_button
        content_tag(:button, type: "button", class: field_classes[:password_button],
                             data: { action: "whose-password-visibility#toggle" }) do
          safe_join([
            content_tag(:span, t("whose.form.show"), data: { whose_password_visibility_target: "icon" }),
            content_tag(:span, t("whose.form.hide"), class: field_classes[:password_hidden],
                                                     data: { whose_password_visibility_target: "icon" })
          ])
        end
      end
    end
  end
end
