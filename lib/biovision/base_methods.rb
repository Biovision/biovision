# frozen_string_literal: true

# Useful helper methods for application
module Biovision
  # Base additional methods for application controller
  module BaseMethods
    extend ActiveSupport::Concern

    included do
      helper_method :visitor_slug
      helper_method :component_handler
      helper_method :current_page, :param_from_request
      helper_method :current_user, :current_language
      helper_method :content_component, :users_component
    end

    # Get current page number from request
    #
    # @return [Integer]
    def current_page
      @current_page ||= (params[:page] || 1).to_s.to_i.abs
    end

    # Get parameter from request and normalize it
    #
    # Casts request parameter to UTF-8 string and removes invalid characters
    #
    # @param [Symbol] param
    # @return [String]
    def param_from_request(*param)
      value = params.dig(*param)
      value.to_s.encode('UTF-8', 'UTF-8', invalid: :replace, replace: '')
    end

    # Get current user from token cookie
    #
    # @return [User|nil]
    def current_user
      @current_user ||= Token.user_by_token(cookies['token'], true)
    end

    # Get current language from locale
    #
    # @return [Language]
    def current_language
      @current_language ||= Language[locale]
    end

    # Get content component handler
    #
    # @return [Biovision::Components::ContentComponent]
    def content_component
      @content_component ||= Biovision::Components::ContentComponent[current_user]
    end

    # Get users component handler
    #
    # @return [Biovision::Components::UsersComponent]
    def users_component
      @users_component ||= Biovision::Components::UsersComponent[current_user]
    end

    # @return [Agent]
    def agent
      @agent ||= Agent[request.user_agent || 'n/a']
    end

    # @return [String]
    def visitor_slug
      if current_user.nil?
        "#{remote_ip}:#{agent.id}"
      else
        current_user.id.to_s
      end
    end

    private

    # Handle generic HTTP error without raising exception
    #
    # @param [Symbol] status
    # @param [String] message
    # @param [String|Symbol] view
    def handle_http_error(status = 500, message = nil, view = :error)
      @message = message || '500: Internal server error'
      logger.warn "#{message}\n\t#{request.method} #{request.original_url}"
      render view, status: status
    end

    # Handle HTTP error with status 401 without raising exception
    #
    # @param [String] message
    # @param [Symbol|String] view
    def handle_http_401(message = nil, view = :unauthorized)
      message ||= t('application.errors.unauthorized')
      handle_http_error(:unauthorized, message, view)
    end

    # Handle HTTP error with status 403 without raising exception
    #
    # @param [String] message
    # @param [Symbol|String] view
    def handle_http_403(message = nil, view = :forbidden)
      message ||= t('application.errors.forbidden')
      handle_http_error(:forbidden, message, view)
    end

    # Handle HTTP error with status 404 without raising exception
    #
    # @param [String] message
    # @param [Symbol|String] view
    def handle_http_404(message = nil, view = :not_found)
      message ||= t('application.errors.not_found')
      handle_http_error(:not_found, message, view)
    end

    # Handle HTTP error with status 503 without raising exception
    #
    # @param [String] message
    # @param [Symbol|String] view
    def handle_http_503(message = nil, view = :service_unavailable)
      message ||= t('application.errors.service_unavailable')
      handle_http_error(:service_unavailable, message, view)
    end

    # Restrict access for anonymous users
    def restrict_anonymous_access
      return unless current_user.nil?

      handle_http_401(t('application.errors.restricted_access'))
    end

    # Owner information for entity
    #
    # @param [TrueClass|FalseClass] track
    def owner_for_entity(track = false)
      result = { user: current_user }
      result.merge!(tracking_for_entity) if track
      result
    end

    # @return [Hash]
    def tracking_for_entity
      {
        agent: agent,
        ip_address: IpAddress[remote_ip]
      }
    end

    def remote_ip
      @remote_ip ||= (request.env['HTTP_X_REAL_IP'] || request.remote_ip)
    end

    # @param [String] next_page
    def form_processed_ok(next_page)
      respond_to do |format|
        format.js { render(js: "document.location.href = '#{next_page}'") }
        format.json { render(json: { links: { next: next_page } }) }
        format.html { redirect_to(next_page) }
      end
    end

    # @param [Symbol|String] view_to_render
    # @param [Array] errors
    def form_processed_with_error(view_to_render, errors = [])
      @errors = errors
      respond_to do |format|
        format.js { render('shared/forms/errors', status: :bad_request) }
        format.json { render('shared/forms/errors', status: :bad_request) }
        format.html { render(view_to_render, status: :bad_request) }
      end
    end

    def component_class
      Biovision::Components::BaseComponent
    end

    def component_handler
      @component_handler ||= component_class[current_user]
    end
  end
end
