# frozen_string_literal: true

module Whose::Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?, :current_user
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def authenticated?
    resume_session.present?
  end

  def current_user
    resume_session&.user
  end

  def after_sign_in_path
    main_app.respond_to?(:root_path) ? main_app.root_path : "/"
  end

  def after_sign_out_path
    new_session_path
  end

  def after_sign_up_path
    new_session_path
  end

  def sign_up_params
    params.expect(user: %i[email_address password password_confirmation])
  end

  def after_sign_up(user); end

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    Whose::Current.session ||= find_session_by_cookie
  end

  def find_session_by_cookie
    Whose::Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
  end

  def request_authentication
    session[:return_to_after_authenticating] = request.url
    redirect_to new_session_path
  end

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || after_sign_in_path
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      Whose::Current.session = session
      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
    end
  end

  def terminate_session
    Whose::Current.session.destroy
    cookies.delete(:session_id)
  end
end
