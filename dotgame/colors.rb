require 'starruby'

module DotGame
  # 色
  module Colors
    def self.define_color(name, r, g=r, b=r, a=255)
      color = StarRuby::Color.new(r, g, b, a)
      define_method(name) { color }
      module_function name
    end

    define_color :white, 255, 255, 255
    define_color :gray, 220, 220, 220
    define_color :black, 0, 0, 0
    define_color :red, 255, 0, 0
    define_color :green, 0, 255, 0
    define_color :blue, 0, 0, 255
    define_color :yellow, 255, 255, 0
    define_color :cyan, 0, 255, 255
    define_color :magenta, 255, 0, 255
    define_color :purple, 128, 0, 128
    define_color :yellow, 255, 255, 0
    define_color :transparent, 255, 255, 255, 0
  end
end
