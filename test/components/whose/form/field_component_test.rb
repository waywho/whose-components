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

  private

  def render_form(model, layout: :vertical, &block)
    render_in_view_context do
      whose_form_with(model:, scope: :person, url: "/people", layout:, &block)
    end
  end
end
