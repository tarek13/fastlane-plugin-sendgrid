require 'fastlane/action'
require_relative '../helper/sendgrid_helper'

module Fastlane
  module Actions
    class SendgridAction < Action
      def self.run(params)
        require 'sendgrid-ruby'
        from = SendGrid::Email.new(email: params[:from], name: params[:username])
        subject = params[:subject]
        content = SendGrid::Content.new(type: 'text/html', value: params[:body])

        mail = SendGrid::Mail.new
        personalization = SendGrid::Personalization.new

        params[:to].each do |item|
          puts(item)
          personalization.add_to(SendGrid::Email.new(email: item))
        end

        params[:cc].each do |item|
          puts(item)
          personalization.add_cc(SendGrid::Email.new(email: item))
        end

        unless params[:references].nil?
          personalization.add_header(SendGrid::Header.new(key: 'References', value: params[:references]))
        end
        unless params[:inReplayTo].nil?
          personalization.add_header(SendGrid::Header.new(key: 'In-Reply-To', value: params[:inReplayTo]))
        end

        mail.add_personalization(personalization)
        mail.subject = subject
        mail.from = from
        mail.contents = content

        sg = SendGrid::API.new(api_key: params[:apiKey])
        response = sg.client.mail._('send').post(request_body: mail.to_json)
        puts(response.status_code)
        puts(response.body)
      end

      def self.description
        "send email with sendgrid"
      end

      def self.authors
        ["OTVENTURES\Tarek.Mohammed"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "send email with sendgrid"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :apiKey,
                                       env_name: "FL_SENDGRID_API_KEY",
                                       description: "Sendgrid api key",
                                       verify_block: proc do |value|
                                         UI.user_error!("No api key") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: "FL_MAIL_USERNAME",
                                       description: "Username for mail",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("No username") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :from,
                                       env_name: "FL_MAIL_FROM",
                                       description: "from for mail",
                                       is_string: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("No from") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :to,
                                       env_name: "FL_MAIL_TO",
                                       description: "Mail to recipients",
                                       sensitive: true,
                                       is_string: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("No recipients") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :cc,
                                       env_name: "FL_MAIL_CC",
                                       description: "Mail cc recipients",
                                       sensitive: true,
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :subject,
                                       env_name: "FL_MAIL_SUBJECT",
                                       description: "The subject of the email",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("No subject of email") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :body,
                                       env_name: "FL_MAIL_BODY",
                                       description: "The body of the email",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("No body of email") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :inReplayTo,
                                       env_name: "FL_MAIL_IN_REPLAY_TO",
                                       description: "Mail in replay To",
                                       sensitive: true,
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :references,
                                       env_name: "FL_MAIL_REFERENCES",
                                       description: "Mail References",
                                       sensitive: true,
                                       is_string: false,
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
