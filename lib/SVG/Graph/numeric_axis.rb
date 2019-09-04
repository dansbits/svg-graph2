module SVG
  module Graph
    class NumericAxis
      attr_accessor :min, :max

      def initialize(min, max, pixel_length)
        @min = min
        @max = max
        @pixel_length = pixel_length
      end

      def labels(label_count: 7)
        space_count = label_count - 1
        space_between = (@max - @min).to_f / space_count.to_f
        (0..space_count).map { |index| @min + (index.to_f * space_between) }
      end

      def value_to_pixel(value, offset: 0)
        range = @max - @min
        value_on_range = value - @min
        (@pixel_length - offset) * (value_on_range.to_f / range.to_f)
      end
    end
  end
end