class SessionsController < Passwordless::SessionsController
  # Override @passwordless/sessions_controller.rb
  def create
    handle_resource_not_found unless @resource = find_authenticatable
    @session = build_passwordless_session(@resource)

    if @session.save
      call_after_session_save

      # Show the token in the flash in development.
      notice = I18n.t("passwordless.sessions.create.email_sent")
      if Rails.env.development?
        Rails.logger.warn("In development: printing login token to the page")
        notice = "[DEVELOPMENT MODE] Your secret token: #{@session.token}"
      end

      redirect_to(
        Passwordless.context.path_for(
          @session,
          id: @session.to_param,
          action: "show",
          **default_url_options
        ),
        flash: {notice: notice}
      )
    else
      flash.alert = I18n.t("passwordless.sessions.create.error")
      render(:new, status: :unprocessable_entity)
    end

  rescue ActiveRecord::RecordNotFound
    @session = Session.new

    flash.alert = I18n.t("passwordless.sessions.create.not_found")
    render(:new, status: :not_found)
  end
end
