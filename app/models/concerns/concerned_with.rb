# frozen_string_literal: true

module ConcernedWith
  def self.included(base)
    base.instance_eval do
      def require_concerns(*concerns)
        default_concerns = %w[
          active_record
          class_methods
          extensions
          instance_methods
          scopes
        ].freeze

        class_name = name.underscore

        (concerns.presence || default_concerns).map(&:to_s).each do |concern|
          filename = "#{class_name}_#{concern}"
          pathname = Rails.root.join('app', 'models', name.underscore, filename).to_s
          File.exist?("#{pathname}.rb") && require_dependency(pathname)
        end
      end
    end
  end
end
