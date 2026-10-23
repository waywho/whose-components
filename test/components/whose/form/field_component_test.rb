# frozen_string_literal: true

require "test_helper"

class Whose::Form::FieldComponentTest < ViewComponent::TestCase
  class Person
    include ActiveModel::Model

    attr_accessor :name, :admin
  end

  def test_field_shows_error_and_marks_input_invalid
    person = Person.new
    person.errors.add(:name, "can't be blank")

    render_form(person) { it.text_field(:name) }

    assert_selector "p#person_name_error", text: "can't be blank"
    assert_selector "input[aria-invalid=true]"
    assert_selector "input[aria-describedby~=person_name_error]"
  end

  def test_horizontal_layout_marks_wrapper
    render_form(Person.new, layout: :horizontal) { it.text_field(:name) }

    assert_selector "[data-layout=horizontal]"
    assert_no_selector "[data-layout=vertical]"
  end

  def test_inline_layout_puts_fields_and_submit_in_one_row
    render_form(Person.new, layout: :inline) do
      it.text_field(:name, hint: "Full name") + it.text_field(:admin) + it.submit("Save")
    end

    assert_selector "[data-form-row] [data-field][data-layout=inline] label[for=person_name]", text: "Name"
    assert_selector "[data-form-row] [data-field] #person_name_hint", text: "Full name"
    assert_selector "[data-form-row] button[type=submit]", text: "Save"
    assert_selector "[data-form-row] [data-field]", count: 2
  end

  def test_other_layouts_have_no_row_wrapper
    render_form(Person.new) { it.text_field(:name) }

    assert_no_selector "[data-form-row]"
  end

  def test_unknown_layout_raises
    assert_raises(ArgumentError) { render_form(Person.new, layout: :diagonal) { it.text_field(:name) } }
  end

  def test_label_defaults_to_humanized_attribute
    render_form(Person.new) { it.text_field(:name) }

    assert_selector "label[for=person_name]", text: "Name"
  end

  def test_check_box_puts_label_after_input
    render_form(Person.new) { it.check_box(:admin, label: "Administrator") }

    assert_selector "input[type=checkbox] + label[for=person_admin]", text: "Administrator"
  end

  def test_check_box_keeps_caller_aria_and_adds_component_aria
    person = Person.new
    person.errors.add(:admin, "must be accepted")

    render_form(person) { it.check_box(:admin, aria: { label: "Accept" }) }

    assert_selector "input[type=checkbox][aria-label=Accept][aria-invalid=true][aria-describedby~=person_admin_error]"
  end

  def test_checkbox_renders_field_wrapper_with_label
    render_form(Person.new) { it.checkbox(:admin) }

    assert_selector "[data-field] input[type=checkbox] + label[for=person_admin]", text: "Admin"
  end

  def test_textarea_renders_field_wrapper_with_label
    render_form(Person.new) { it.textarea(:name) }

    assert_selector "[data-field] label[for=person_name]", text: "Name"
    assert_selector "[data-field] textarea.rounded-box"
  end

  def test_text_area_alias_renders_field_wrapper
    render_form(Person.new) { it.text_area(:name) }

    assert_selector "[data-field] textarea.rounded-box"
  end

  def test_phone_field_renders_field_wrapper_with_label
    render_form(Person.new) { it.phone_field(:name) }

    assert_selector "[data-field] label[for=person_name]", text: "Name"
    assert_selector "[data-field] input[type=tel].rounded-box"
  end

  def test_telephone_field_renders_field_wrapper
    render_form(Person.new) { it.telephone_field(:name) }

    assert_selector "[data-field] input[type=tel].rounded-box"
  end

  def test_password_field_has_show_hide_button
    render_form(Person.new) { it.password_field(:name) }

    assert_selector "[data-controller=whose-password-visibility] input[type=password][data-whose-password-visibility-target=input].pr-16"
    assert_selector "button[data-action='whose-password-visibility#toggle']", text: "Show"
    assert_selector "button[data-action='whose-password-visibility#toggle'] span", text: "Hide", visible: :all
  end

  def test_password_toggle_button_has_focus_ring
    render_form(Person.new) { it.password_field(:name) }

    assert_selector "button[data-action='whose-password-visibility#toggle'].focus-visible\\:outline-2.focus-visible\\:outline-offset-2.focus-visible\\:outline-accent"
  end

  def test_submit_renders_submit_button
    render_form(Person.new) { it.submit("Save") }

    assert_selector "button[type=submit]", text: "Save"
  end

  def test_placeholder_labels_put_the_label_in_the_placeholder_and_hide_it
    render_form(Person.new, labels: :placeholder) { it.text_field(:name) + it.textarea(:admin) }

    assert_selector "input#person_name[placeholder=Name]"
    assert_selector "textarea#person_admin[placeholder=Admin]"
    assert_selector "label.sr-only[for=person_name]", text: "Name", visible: :all
    assert_no_selector "label[for=person_name]:not(.sr-only)", visible: :all
  end

  def test_placeholder_labels_keep_a_placeholder_that_the_field_sets
    render_form(Person.new, labels: :placeholder) { it.text_field(:name, placeholder: "Ann Lee") }

    assert_selector "input#person_name[placeholder='Ann Lee']"
  end

  def test_placeholder_labels_keep_visible_labels_on_fields_without_a_placeholder
    render_form(Person.new, labels: :placeholder) do
      it.select(:name, %w[Ann Bob]) + it.checkbox(:admin)
    end

    assert_selector "label[for=person_name]:not(.sr-only)", text: "Name"
    assert_selector "label[for=person_admin]:not(.sr-only)", text: "Admin"
  end

  def test_placeholder_labels_drop_the_label_spacer_in_an_inline_form
    render_form(Person.new, layout: :inline, labels: :placeholder) { it.text_field(:name) + it.submit("Save") }

    assert_no_selector "[data-form-row] span[aria-hidden=true]", visible: :all
  end

  TYPED_FIELDS = {
    search_field: "search", datetime_field: "datetime-local", datetime_local_field: "datetime-local", time_field: "time",
    month_field: "month", week_field: "week", color_field: "color", range_field: "range"
  }.freeze

  TYPED_FIELDS.each do |helper, type|
    define_method(:"test_#{helper}_renders_field_wrapper_with_label_hint_and_error") do
      person = Person.new
      person.errors.add(:name, "is invalid")

      render_form(person) { it.public_send(helper, :name, hint: "A hint") }

      assert_selector "[data-field] label[for=person_name]", text: "Name"
      assert_selector "[data-field] input[type=#{type}].rounded-box[aria-invalid=true]"
      assert_selector "#person_name_hint", text: "A hint"
      assert_selector "#person_name_error", text: "is invalid"
    end
  end

  def test_search_field_takes_the_placeholder_label
    render_form(Person.new, labels: :placeholder) { it.search_field(:name) }

    assert_selector "input[type=search]#person_name[placeholder=Name]"
    assert_selector "label.sr-only[for=person_name]", visible: :all
  end

  def test_color_and_range_fields_keep_visible_labels_in_placeholder_mode
    render_form(Person.new, labels: :placeholder) { it.color_field(:name) + it.range_field(:admin) }

    assert_no_selector "input[placeholder]"
    assert_selector "label[for=person_name]:not(.sr-only)", text: "Name"
    assert_selector "label[for=person_admin]:not(.sr-only)", text: "Admin"
  end

  def test_collection_select_renders_field_wrapper_with_label_hint_and_options
    render_form(Person.new) do
      it.collection_select(:name, [ %w[Ann ann], %w[Bob bob] ], :last, :first, { label: "Who", hint: "Pick one" })
    end

    assert_selector "[data-field] label[for=person_name]", text: "Who"
    assert_selector "[data-field] select.rounded-box#person_name option[value=bob]", text: "Bob"
    assert_selector "#person_name_hint", text: "Pick one"
  end

  def test_collection_select_marks_invalid_input
    person = Person.new
    person.errors.add(:name, "is invalid")

    render_form(person) { it.collection_select(:name, [ %w[Ann ann] ], :last, :first) }

    assert_selector "select[aria-invalid=true][aria-describedby~=person_name_error]"
  end

  def test_radio_button_is_styled_without_a_field_wrapper
    render_form(Person.new) { it.radio_button(:name, "ann") }

    assert_selector "input[type=radio]#person_name_ann.accent-accent"
    assert_no_selector "[data-field]"
  end

  def test_radio_group_is_labelled_by_its_label_and_puts_each_label_after_its_radio
    render_form(Person.new) do
      it.collection_radio_buttons(:name, [ %w[Ann ann], %w[Bob bob] ], :last, :first, { label: "Who" })
    end

    assert_selector "[data-field][role=group][aria-labelledby=person_name_label]"
    assert_selector "#person_name_label", text: "Who"
    assert_selector "input[type=radio]#person_name_ann.accent-accent + label[for=person_name_ann]", text: "Ann"
    assert_selector "input[type=radio]#person_name_bob + label[for=person_name_bob]", text: "Bob"
  end

  def test_radio_group_shows_hint_and_error_once_and_every_radio_points_to_them
    person = Person.new
    person.errors.add(:name, "is invalid")

    render_form(person) do
      it.collection_radio_buttons(:name, [ %w[Ann ann], %w[Bob bob] ], :last, :first, { hint: "Pick one" })
    end

    assert_selector "#person_name_hint", text: "Pick one", count: 1
    assert_selector "#person_name_error", text: "is invalid", count: 1
    assert_selector "input[type=radio][aria-invalid=true][aria-describedby='person_name_hint person_name_error']", count: 2
  end

  def test_field_outside_a_group_has_no_group_role
    render_form(Person.new) { it.text_field(:name) }

    assert_no_selector "[data-field][role]"
    assert_no_selector "[data-field][aria-labelledby]"
  end

  def test_radio_group_keeps_a_visible_label_in_placeholder_mode
    render_form(Person.new, labels: :placeholder) do
      it.collection_radio_buttons(:name, [ %w[Ann ann] ], :last, :first)
    end

    assert_selector "#person_name_label:not(.sr-only)", text: "Name"
  end

  def test_input_keeps_caller_describedby_and_joins_hint_and_error_ids
    person = Person.new
    person.errors.add(:name, "is invalid")

    render_form(person) { it.text_field(:name, hint: "A hint", aria: { describedby: "extra" }) }

    assert_selector "input[aria-describedby='extra person_name_hint person_name_error']"
  end

  def test_input_keeps_caller_describedby_when_there_is_no_hint_or_error
    render_form(Person.new) { it.text_field(:name, aria: { describedby: "extra" }) }

    assert_selector "input[aria-describedby=extra]"
  end

  def test_checkbox_keeps_caller_describedby_and_joins_hint_id
    render_form(Person.new) { it.checkbox(:admin, hint: "A hint", aria: { describedby: "extra" }) }

    assert_selector "input[type=checkbox][aria-describedby='extra person_admin_hint']"
  end

  def test_select_renders_field_wrapper_with_label_hint_and_error
    person = Person.new
    person.errors.add(:name, "is invalid")

    render_form(person) { it.select(:name, %w[Ann Bob], { label: "Who", hint: "Pick one" }) }

    assert_selector "[data-field] label[for=person_name]", text: "Who"
    assert_selector "[data-field] select.rounded-box#person_name option", text: "Bob"
    assert_selector "#person_name_hint", text: "Pick one"
    assert_selector "select[aria-invalid=true][aria-describedby='person_name_hint person_name_error']"
  end

  def test_toggle_renders_a_switch_with_label_after_input
    render_form(Person.new) { it.toggle(:admin, label: "Admin access", hint: "A hint") }

    assert_selector "[data-field] input[type=checkbox][role=switch].appearance-none + label[for=person_admin]", text: "Admin access"
    assert_selector "input[aria-describedby=person_admin_hint]"
  end

  def test_file_field_renders_field_wrapper_with_label_and_error
    person = Person.new
    person.errors.add(:name, "is invalid")

    render_form(person) { it.file_field(:name, hint: "A hint") }

    assert_selector "[data-field] label[for=person_name]", text: "Name"
    assert_selector "[data-field] input[type=file].file\\:bg-accent-soft[aria-invalid=true]"
    assert_selector "#person_name_hint", text: "A hint"
  end

  def test_unknown_labels_option_raises
    assert_raises(ArgumentError) { render_form(Person.new, labels: :floating) { it.text_field(:name) } }
  end

  private

  def render_form(model, layout: :vertical, labels: :visible, &block)
    render_in_view_context do
      whose_form_with(model:, scope: :person, url: "/people", layout:, labels:, &block)
    end
  end
end
