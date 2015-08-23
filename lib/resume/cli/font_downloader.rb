require 'tmpdir'
require_relative '../network_connection_error'
require_relative '../file_fetcher'

module Resume
  module CLI
    class FontDownloader
      attr_reader :fonts

      def initialize(fonts)
        @fonts = fonts
      end

      def audit_font_dependencies
        fonts.each do |font|
          fonts.delete(font) if files_present?(font[:files].values)
        end
      end

      def output_font_dependencies
        Output.warning(:custom_fonts)
      end

      def fonts_successfully_downloaded?
        return true if fonts.none?
        fonts.all? do |font|
          Output.plain([
            :downloading_font,
            { file_name: font[:file_name], location: font[:location] }
          ])
          download_font_file(font)
          extract_fonts(font)
        end
      end

      private

      def files_present?(files)
        files.all? { |file| File.exist?(FileSystem.tmp_filepath(file)) }
      end

      def download_font_file(font)
        File.open(FileSystem.tmp_filepath(font[:file_name]), 'wb') do |file|
          FileFetcher.fetch(font[:location]) do |uri|
            file.write(uri.read)
          end
        end
      rescue SocketError, OpenURI::HTTPError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      end

      def extract_fonts(font)
        require 'zip'
        Zip::File.open(FileSystem.tmp_filepath(font[:file_name])) do |file|
          file.each do |entry|
            font[:files].each do |_, file_name|
              if entry.name.match(file_name)
                # overwrite any existing files with true block
                entry.extract(FileSystem.tmp_filepath(file_name)) { true }
                break # inner loop only
              end
            end
          end
        end
      end
    end
  end
end