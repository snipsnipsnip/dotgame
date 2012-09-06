
module DotGame
  class DotFont
    def initialize(arr)
      @font = arr
    end
    
    def draw_text(screen, x, y, msg, scale, color)
      ix = x
      msg.to_s.each_byte do |c|
        if c == 10
          x = ix
          y += 5 * scale + 1
        else
          c -= 32
          draw_letter(screen, x, y, c, scale, color)
          x += 5 * scale + 1
        end
      end
    end
    
    def draw_text_bold(screen, x, y, msg, scale, inner, outer)
      x += 1
      y += 1
      ix = x
      msg.to_s.each_byte do |c|
        if c == 10
          x = ix
          y += 6 * scale + 1
        else
          c -= 32
          ShinhFont.draw_letter(screen, x + 1, y, c, scale, outer)
          ShinhFont.draw_letter(screen, x - 1, y, c, scale, outer)
          ShinhFont.draw_letter(screen, x, y + 1, c, scale, outer)
          ShinhFont.draw_letter(screen, x, y - 1, c, scale, outer)
          ShinhFont.draw_letter(screen, x, y, c, scale, inner)
          x += 7 * scale + 1
        end
      end
    end
    
    def draw_letter(screen, x, y, i, scale, color)
      unless 0 <= i && i < @font.size
        raise IndexError, "index #{i} out of font array"
      end
      
      screen.render_texture font_cache, x, y, {
        :src_width => 5,
        :src_height => 5,
        :src_x => i * 5,
        :tone_red => color.red,
        :tone_green => color.green,
        :tone_blue => color.blue,
        :scale_x => scale,
        :scale_y => scale,
      }
    end
    
    private
    def font_cache
      @cache ||= make_cache
    end
    
    def make_cache
      tex = make_texture(@font.size * 5, 5)
      tex.fill transparent
      @font.each_with_index do |chara, i|
        plot_letter(tex, i * 5, 0, chara, black)
      end
      tex
    end
    
    def make_texture(w, h)
      StarRuby::Texture.new(w, h)
    end

    def plot_letter(screen, x, y, letter, color)
      5.times do |j|
        5.times do |i|
          screen[x + i, y + j] = color unless letter[0].zero?
          letter >>= 1
        end
      end
    end
  end
end
