require_relative "Graph"
require_relative "numeric_axis"

module SVG
  module Graph
    class Histogram < Graph

      attr_accessor :bin_sets
      
      def burn
        build_bins
        super
      end

      def get_y_labels
        build_y_axis
        @y_axis.labels
      end

      def draw_data
        colors = ["red","blue"]
        @bin_sets.each_with_index do |bin_set, index|
          bin_set.each do |bin|
            x = @x_axis.value_to_pixel(bin[:start])
            x_width = @x_axis.value_to_pixel(bin[:end]) - x
            y = @graph_height - @y_axis.value_to_pixel(bin[:count], offset: field_height)
            y_height = @graph_height - y
            @graph.add_element(
              'rect',
              {
                "x" => x,
                "y" => y,
                "width" => x_width,
                "height" => y_height,
                "style" => "fill:#{colors[index]};opacity: 0.5;"
              }
            )
          end
        end
      end

      private

      def build_x_axis
        @x_axis = NumericAxis.new(min_value, max_value, @graph_width)
      end

      def build_y_axis
        min = 0
        max = @bin_sets.map { |bins| bins.map { |bin| bin[:count] }.max }.max
        @y_axis = NumericAxis.new(min, max, @graph_height)
      end

      def build_bins
        @bin_sets = @data.map do |dataset|
          nbins = Math.sqrt(dataset[:data].count).ceil
          min = dataset[:data].min
          max = dataset[:data].max
          bin_width = (max - min).to_f / nbins.to_f

          (0..(nbins - 1)) .map do |bin_index|
            bin_start = min + (bin_index * bin_width)
            bin_end = bin_start + bin_width
            count = dataset[:data].count { |value| value >= bin_start && value < bin_end }
            { start: bin_start , end: bin_end, count: count }
          end
        end
      end

      def get_x_labels
        build_x_axis
        @x_axis.labels
      end

      def min_value
        @data.map { |dataset| dataset[:data].min }.min
      end

      def max_value
        @data.map { |dataset| dataset[:data].max }.max
      end

      def get_css
        ""
      end
    end
  end
end