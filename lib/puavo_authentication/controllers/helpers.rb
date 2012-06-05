module PuavoAuthentication
  module Controllers
    module Helpers

      attr_accessor :authentication

      def token_manager
        @token_manager ||= Puavo::OAuth::TokenManager.new Puavo::OAUTH_CONFIG["token_key"]
      end

      # Lazy getter for current user object
      def current_user

        if @authentication.nil?
          raise "Cannot call 'current_user' before 'setup_authentication'"
        end

        @authentication.current_user

      end

      # Returns [oauth_dn, password] if user supplied "Authorization: token <data>" header
      def oauth_credentials
        if auth_header = request.headers["HTTP_AUTHORIZATION"]
          type, data = auth_header.split
          if type.downcase == "token"
            token = AccessToken.decrypt data
            return token["dn"], token["password"]
          end
        end
        return nil
      end

      # Returns user dn and password for some available login mean
      def login_credentials

        if oc = oauth_credentials
          logger.debug "Using OAuth authentication with #{ oc[0] }"
          return oc
        end

        authenticate_with_http_basic do |username, password|
          logger.debug "Using basic authentication with #{ username }"

          if username.match(/^oauth_client_id\//)
            oauth_client_id = username.match(/^oauth_client_id\/(.*)/)[1]
            if oauth_client_server = OauthClient.find(:first,
              :attribute => "puavoOAuthClientId",
              :value => oauth_client_id)
              return oauth_client_server.dn, password
            end
          end

          if username.match(/^service\//)
            uid = username.match(/^service\/(.*)/)[1]
          end

          return User.uid_to_dn(uid), password, uid
        end

        if uid = session[:uid]
          logger.debug "Using session authentication with #{ uid }"
          return User.uid_to_dn(uid), session[:password_plaintext], uid
        end


      end

      # Before filter
      # Setup authentication object with default credentials from
      # config/ldap.yml
      def setup_authentication

        @authentication = Puavo::Authentication.new

        # First configure ActiveLdap to use the default configuration from
        # ldap.yml. This allows Puavo to search user dn from user uids.
        default_ldap_configuration = ActiveLdap::Base.ensure_configuration
        @authentication.configure_ldap_connection(
          default_ldap_configuration["bind_dn"],
          default_ldap_configuration["password"],
          session[:organisation].ldap_host,
          session[:organisation].ldap_base)

      end

      # Before filter
      # Require user login credentials
      def require_login

        if @authentication && @authentication.authenticated
          logger.debug "Already required login with #{ @authentication.dn }"
          return
        end


        begin
          dn, password, uid = login_credentials
        rescue Puavo::UnknownUID => e
          logger.info "Failed to get credentials: #{ e.message }"
          show_authentication_error "unknown_credentials", t('flash.session.failed')
          return false
        rescue AccessToken::Expired => e
          show_authentication_error "expired_credentials", t('flash.session.failed')
          return false
        end

        if dn.nil?
          logger.debug "No credentials supplied"
          show_authentication_error "no_credentials", t('must_be_logged_in')
          return false
        end

        # Configure ActiveLdap to use user dn and password
        @authentication.configure_ldap_connection dn, password

        begin
          @authentication.authenticate
        rescue Puavo::AuthenticationError => e
          logger.info "Login failed for #{ dn } (#{ uid }): #{ e }"
          show_authentication_error "bad_credentials", t('flash.session.failed')
          return false
        end

        if session[:login_flash]
          flash[:notice] = session[:login_flash]
          session.delete :login_flash
        end

        nil
      end

      # Before filter
      # Require Puavo access rights
      def require_puavo_authorization

        # Unauthorized always when not authenticated
        return false unless @authentication

        begin
          @authentication.authorize
        rescue Puavo::AuthorizationFailed => e
          logger.info "Authorization  failed: #{ e }"
          show_authentication_error "unauthorized", t('flash.session.failed')
          return false
        end
      end

      def show_authentication_error(code, message)
        session.delete :password_plaintext
        session.delete :uid
        if request.format == Mime::JSON
          render(:json => {
            :error => code,
            :message => message,
          }.to_json,
          :status => 400)
        else
          store_location
          flash[:notice] = message
          redirect_to login_path
        end
      end

      def store_location
        session[:return_to] = request.request_uri
      end

      def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
      end

      def remove_ldap_connection
        Puavo::Authentication.remove_connection
      end

    end
  end
end
