class UserAgent
  module Browsers
    class Edge < Base
      OS_REGEXP = /Windows NT [\d\.]+|Windows Phone (OS )?[\d\.]+/

      def self.extend?(agent)
        agent.detect { |useragent| useragent.product.include?("Edg") }
      end

      def browser
        "Edge"
      end

      def version
        last.version
      end

      def platform
        return unless application

        if application.comment[0] =~ /Windows/
          'Windows'
        elsif application.comment.any? { |c| c =~ /CrOS/ }
          'EdgeOS'
        elsif application.comment.any? { |c| c =~ /Android/ }
          'Android'
        else
          application.comment[0]
        end
      end

      def application
        self.reject { |agent| agent.comment.nil? || agent.comment.empty? }.first
      end

      def os
        return unless application

        if application.comment[0] =~ /Windows NT/
          OperatingSystems.normalize_os(application.comment[0])
        elsif application.comment[2].nil?
          OperatingSystems.normalize_os(application.comment[1])
        elsif application.comment[1] =~ /Android/
          OperatingSystems.normalize_os(application.comment[1])
        else
          OperatingSystems.normalize_os(application.comment[2])
        end

      end

      private

      def os_comment
        detect_comment_match(OS_REGEXP).to_s
      end
    end
  end
end
