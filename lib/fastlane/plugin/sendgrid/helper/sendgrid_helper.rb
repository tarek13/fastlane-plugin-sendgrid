require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class SendgridHelper
      # class methods that you define here become available in your action
      # as `Helper::SendgridHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the sendgrid plugin helper!")
      end
    end
  end
end
