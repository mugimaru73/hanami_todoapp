require 'hanami/helpers'
require 'hanami/assets'

module Api
  CORS_HEADERS = {
    "Access-Control-Allow-Origin" => "*",
    "Access-Control-Allow-Methods" => %w{GET POST PUT PATCH OPTIONS DELETE}.join(','),
    "Access-Control-Allow-Headers" => %w{Content-Type Accept}.join(',')
  }

  class Application < Hanami::Application
    configure do
      root __dir__

      load_paths << [
        'controllers'
      ]

      routes 'config/routes'

      default_request_format :json
      default_response_format :json
      body_parsers :json

      security.x_frame_options 'DENY'
      security.x_content_type_options 'nosniff'
      # security.x_xss_protection '1; mode=block'
      security.content_security_policy %{
        form-action 'self';
        frame-ancestors 'self';
        base-uri 'self';
        default-src 'none';
        script-src 'self';
        connect-src 'self';
        img-src 'self' https: data:;
        style-src 'self' 'unsafe-inline' https:;
        font-src 'self';
        object-src 'none';
        plugin-types application/pdf;
        child-src 'self';
        frame-src 'self';
        media-src 'self'
      }

      controller.default_headers(CORS_HEADERS)

      controller.prepare do
        # include MyAuthentication # included in all the actions
        # before :authenticate!    # run an authentication before callback
      end
    end

    configure :development do
      handle_exceptions false
    end

    configure :test do
      handle_exceptions false
    end

    configure :production do
    end
  end
end
