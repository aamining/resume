require_relative "exceptions"
require_relative "exception_suppressor"
require_relative "file_fetcher"

module Resume
  module CLI
    # Module responsible for setting up gem and internationalisation
    # configuration for the resume before running generation commands.
    #
    # @author Paul Fioravanti
    module Settings
      # List of locales the resume supports
      AVAILABLE_LOCALES = %i[en it ja].freeze
      private_constant :AVAILABLE_LOCALES
      # Locale file location
      LOCALE_FILE = ->(locale) { "lib/resume/locales/#{locale}.yml" }
      private_constant :LOCALE_FILE

      module_function

      # Configures gems and i18n for resume generation.
      #
      # @raise [DependencyPreprequisiteError]
      #   if the `i18n` gem is not installed.
      # @return [Array] The list of available locales.
      def configure
        # Ignore requiring gems that are used just for development
        ExceptionSuppressor.suppress(LoadError) do
          require "pry-byebug"
        end
        configure_i18n
      end

      def configure_i18n
        require "i18n"
        I18n.available_locales = AVAILABLE_LOCALES
        I18n.available_locales.each do |locale|
          I18n.load_path += [
            FileFetcher.fetch(LOCALE_FILE.call(locale))
          ]
        end
      rescue LoadError
        raise DependencyPrerequisiteError
      end
      private_class_method :configure_i18n
    end
  end
end
