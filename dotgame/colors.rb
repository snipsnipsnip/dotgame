require 'starruby'

module DotGame
  # 色
  module Colors
    def self.define_color(name, r, g=r, b=r, a=255)
      color = r.is_a?(StarRuby::Color) ? r : StarRuby::Color.new(r, g, b, a)
      define_method(name) { color }
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
    
    # 色を作る
    # 例: yellow = Color(255, 255, 0)
    def Color(r, g, b, a=255)
      StarRuby::Color.new(r, g, b, a)
    end
  end
end
