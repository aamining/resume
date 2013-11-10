module ResumeGenerator
  class Logo
    # attr_reader :organisation, :origin, :width, :height, :fit, :move_up,
    #   :bars, :size
    LOGO_CONFIG = {
      rc: {
        organisation: 'rc',
        origin: 415,
        width: 115,
        height: 40,
        fit: [110, 40],
        move_up: 40,
        bars: 10,
        size: 43
      },
      ruby: {
        organisation: 'ruby',
        origin: 440,
        width: 37,
        height: 33,
        fit: [31, 31],
        move_up: 30,
        bars: 4,
        size: 34
      },
      rails: {
        organisation: 'rails',
        origin: 480,
        width: 32,
        height: 34,
        fit: [31, 31],
        move_up: 30,
        bars: 3,
        size: 35
      }
    }

    def self.for(position)
      LOGO_CONFIG.fetch(:"#{position}")
    end
    # def initialize(options)
    #   # options.each do |attribute, value|
    #   #   instance_variable_set("@#{attribute}", value)
    #   # end
    #   @organisation = options[:organisation]
    #   @origin = options[:origin]
    #   @width = options[:width]
    #   @height = options[:height]
    #   @fit = options[:fit]
    #   @move_up = options[:move_up]
    #   @bars = options[:bars]
    #   @size = options[:size]
    # end
  end
end