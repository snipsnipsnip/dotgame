
class DotFont
  def initialize(arr)
    @font = arr
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
    tex = StarRuby::Texture.new(@font.size * 5, 5)
    tex.fill transparent
    @font.each_with_index do |chara, i|
      plot_letter(tex, i * 5, 0, chara, black)
    end
    tex
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
