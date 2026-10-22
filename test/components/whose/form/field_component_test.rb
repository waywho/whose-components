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

    render_form(person) { |form| form.text_field(:name) }

    assert_selector "p#person_name_error", text: "can't be blank"
    assert_selector "input[aria-invalid=true]"
    assert_selector "input[aria-describedby~=person_name_error]"
  end

  def test_horizontal_layout_marks_wrapper
    render_form(Person.new, layout: :horizontal) { |form| form.text_field(:name) }

    assert_selector "[data-layout=horizontal]"
    assert_no_selector "[data-layout=vertical]"
  end

  def test_inline_layout_puts_fields_and_submit_in_one_row
    render_form(Person.new, layout: :inline) do |form|
      form.text_field(:name, hint: "Full name") + form.text_field(:admin) + form.submit("Save")
    end

    assert_selector "[data-form-row] [data-field][data-layout=inline] label[for=person_name]", text: "Name"
    assert_selector "[data-form-row] [data-field] #person_name_hint", text: "Full name"
    assert_selector "[data-form-row] button[type=submit]", text: "Save"
    assert_selector "[data-form-row] [data-field]", count: 2
  end

  def test_other_layouts_have_no_row_wrapper
    render_form(Person.new) { |form| form.text_field(:name) }

    assert_no_selector "[data-form-row]"
  end

  def test_unknown_layout_raises
    assert_raises(ArgumentError) { render_form(Person.new, layout: :diagonal) { |form| form.text_field(:name) } }
  end

  def test_label_defaults_to_humanized_attribute
    render_form(Person.new) { |form| form.text_field(:name) }

    assert_selector "label[for=person_name]", text: "Name"
  end

  def test_check_box_puts_label_after_input
    render_form(Person.new) { |form| form.check_box(:admin, label: "Administrator") }

    assert_selector "input[type=checkbox] + label[for=person_admin]", text: "Administrator"
  end

  def test_check_box_keeps_caller_aria_and_adds_component_aria
    person = Person.new
    person.errors.add(:admin, "must be accepted")

    render_form(person) { |form| form.check_box(:admin, aria: { label: "Accept" }) }

    assert_selector "input[type=checkbox][aria-label=Accept][aria-invalid=true][aria-describedby~=person_admin_error]"
  end

  def test_checkbox_renders_field_wrapper_with_label
    render_form(Person.new) { |form| form.checkbox(:admin) }

    assert_selector "[data-field] input[type=checkbox] + label[for=person_admin]", text: "Admin"
  end

  def test_textarea_renders_field_wrapper_with_label
    render_form(Person.new) { |form| form.textarea(:name) }

    assert_selector "[data-field] label[for=person_name]", text: "Name"
    assert_selector "[data-field] textarea.rounded-box"
  end

  def test_text_area_alias_renders_field_wrapper
    render_form(Person.new) { |form| form.text_area(:name) }

    assert_selector "[data-field] textarea.rounded-box"
  end

  def test_phone_field_renders_field_wrapper_with_label
    render_form(Person.new) { |form| form.phone_field(:name) }

    assert_selector "[data-field] label[for=person_name]", text: "Name"
    assert_selector "[data-field] input[type=tel].rounded-box"
  end

  def test_telephone_field_renders_field_wrapper
    render_form(Person.new) { |form| form.telephone_field(:name) }

    assert_selector "[data-field] input[type=tel].rounded-box"
  end

  def test_password_field_has_show_hide_button
    render_form(Person.new) { |form| form.password_field(:name) }

    assert_selector "[data-controller=whose-password-visibility] input[type=password][data-whose-password-visibility-target=input].pr-16"
    assert_selector "button[data-action='whose-password-visibility#toggle']", text: "Show"
    assert_selector "button[data-action='whose-password-visibility#toggle'] span", text: "Hide", visible: :all
  end

  def test_submit_renders_submit_button
    render_form(Person.new) { |form| form.submit("Save") }

    assert_selector "button[type=submit]", text: "Save"
  end

  def test_placeholder_labels_put_the_label_in_the_placeholder_and_hide_it
    render_form(Person.new, labels: :placeholder) { |form| form.text_field(:name) + form.textarea(:admin) }

    assert_selector "input#person_name[placeholder=Name]"
    assert_selector "textarea#person_admin[placeholder=Admin]"
    assert_selector "label.sr-only[for=person_name]", text: "Name", visible: :all
    assert_no_selector "label[for=person_name]:not(.sr-only)", visible: :all
  end

  def test_placeholder_labels_keep_a_placeholder_that_the_field_sets
    render_form(Person.new, labels: :placeholder) { |form| form.text_field(:name, placeholder: "Ann Lee") }

    assert_selector "input#person_name[placeholder='Ann Lee']"
  end

  def test_placeholder_labels_keep_visible_labels_on_fields_without_a_placeholder
    render_form(Person.new, labels: :placeholder) do |form|
      form.select(:name, %w[Ann Bob]) + form.checkbox(:admin)
    end

    assert_selector "label[for=person_name]:not(.sr-only)", text: "Name"
    assert_selector "label[for=person_admin]:not(.sr-only)", text: "Admin"
  end

  def test_placeholder_labels_drop_the_label_spacer_in_an_inline_form
    render_form(Person.new, layout: :inline, labels: :placeholder) { |form| form.text_field(:name) + form.submit("Save") }

    assert_no_selector "[data-form-row] span[aria-hidden=true]", visible: :all
  end

  def test_unknown_labels_option_raises
    assert_raises(ArgumentError) { render_form(Person.new, labels: :floating) { |form| form.text_field(:name) } }
  end

  private

  def render_form(model, layout: :vertical, labels: :visible, &block)
    render_in_view_context do
      whose_form_with(model:, scope: :person, url: "/people", layout:, labels:, &block)
    end
  end
end
