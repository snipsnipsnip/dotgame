# dotgame: starruby for dummies
# https://gist.github.com/962107

require 'starruby'
require 'kconv'

module DotGame

VERSION = "0.0.4"

include Math

# �F #

def white
  Color(255, 255, 255)
end

def gray
  Color(220, 220, 220)
end

def black
  Color(0, 0, 0)
end

def red
  Color(255, 0, 0)
end

def green
  Color(0, 255, 0)
end

def blue
  Color(0, 0, 255)
end

def yellow
  Color(255, 255, 0)
end

# �`�� #

# �_��ł�
#
# �����F
#   dot X���W, Y���W
#   dot X���W, Y���W, �F�̖��O (red, blue, green..)
#   dot X���W, Y���W, �F�̔Z�� (0�`255)
#   dot X���W, Y���W, R, G, B
#
# ��F
#   dot 10, 10
#   dot 3, 3
#   dot 10, 10, 50
#   dot 10, 10, 50, 200, 50
def dot(x, y, r=0, g=nil, b=nil, a=255, s=StarRuby::Game.current.screen)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  s.render_pixel x, y, color
end

# ��������
#
# �����F
#   line ���Ƃ�X���W, ���Ƃ�Y���W, ���X���W, ���Y���W
#   line ���Ƃ�X���W, ���Ƃ�Y���W, ���X���W, ���Y���W
#   line ���Ƃ�X���W, ���Ƃ�Y���W, ���X���W, ���Y���W, �F�̖��O (red, blue, green..)
#   line ���Ƃ�X���W, ���Ƃ�Y���W, ���X���W, ���Y���W, �F�̔Z�� (0�`255)
#   line ���Ƃ�X���W, ���Ƃ�Y���W, ���X���W, ���Y���W, R, G, B
#
# ��F
#   line 10, 10, 50, 200, red
def line(x1, y1, x2, y2, r=0, g=nil, b=nil, a=255, s=StarRuby::Game.current.screen)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  s.render_line x1, y1, x2, y2, color
end

# ��������
#
# �����F
#   square �����X���W, �����Y���W, ����, �c��
#
# ��F
#   square 10, 10, 5, 5, blue
def square(x, y, w, h, r=0, g=nil, b=nil, a=255, s=StarRuby::Game.current.screen)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  s.render_rect x, y, w, h, color
end

# �摜�𒣂�t����
# �t�H���_�z���Ɏw�肷��ꍇ \ �ł͂Ȃ� / ���g������
#
# �����F
#   image "�t�@�C����"
#   image "�t�@�C����", �����X���W, �����Y���W
#   image "�t�@�C����", �����X���W, �����Y���W, �{��
#
# ��F
#   image "neko.bmp"
#   image "c:/tree.gif", 5, 5
#   image "c:/face.png", 3, 3, 2
def image(name, x=0, y=0, scale=nil, s=StarRuby::Game.current.screen)
  opt = scale.is_a?(Hash) ? scale : { :scale_x => scale, :scale_y => scale } if scale
  if t = name.is_a?(String) ? DotGame.get_texture(name) : name
    s.render_texture t, x, y, opt
  else
    warn "\211\346\221\234 '#{name}' \202\252\223\307\202\335\215\236\202\337\202\334\202\271\202\361\202\305\202\265\202\275"
  end
end

def self.get_texture(name)
  @_textures ||= {}
  @_textures[name] ||= StarRuby::Texture.load(name)
end

# �p����������
#
# �����F
#   text �ϐ���
#   text ���l
#   text "���b�Z�[�W"
#   text "���b�Z�[�W", �����X���W, �����Y���W
#   text "���b�Z�[�W", �����X���W, �����Y���W, �F�̖��O (red, blue, green..)
#   text "���b�Z�[�W", �����X���W, �����Y���W, �F�̔Z�� (0�`255)
#   text "���b�Z�[�W", �����X���W, �����Y���W, R, G, B
#
# ��F
#   text 100
#   text "hoge"
#   text "hoge", 5, 5
def text(msg, x=0, y=0, r=0, g=nil, b=nil, a=255, s=StarRuby::Game.current.screen)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  ix = x
  msg.to_s.each_byte do |c|
    if c == 10
      x = ix
      y += 6
    else
      DotGame.draw_letter(s, x, y, c, color)
      x += 6
    end
  end
end

# �t�`��text
def textbold(msg, x=0, y=0, inner=white, outer=black, s=StarRuby::Game.current.screen)
  x += 1
  y += 1
  ix = x
  msg.to_s.each_byte do |c|
    if c == 10
      x = ix
      y += 7
    else
      DotGame.draw_letter_bold(s, x, y, c, inner, outer)
      x += 8
    end
  end
end

# 5x5 bitmap font by shinh (http://d.hatena.ne.jp/shinichiro_h/20060814#1155567183)
# Licensed under the New BSD License.
ShinhFont = [
    0x00000000, 0x00401084, 0x0000014a, 0x00afabea, 0x01fa7cbf, 0x01111111,
    0x0126c8a2, 0x00000084, 0x00821088, 0x00221082, 0x015711d5, 0x00427c84,
    0x00220000, 0x00007c00, 0x00400000, 0x00111110, 0x00e9d72e, 0x00421084,
    0x01f2222e, 0x00e8b22e, 0x008fa54c, 0x01f87c3f, 0x00e8bc2e, 0x0042221f,
    0x00e8ba2e, 0x00e87a2e, 0x00020080, 0x00220080, 0x00820888, 0x000f83e0,
    0x00222082, 0x0042222e, 0x00ead72e, 0x011fc544, 0x00f8be2f, 0x00e8862e,
    0x00f8c62f, 0x01f0fc3f, 0x0010bc3f, 0x00e8e42e, 0x0118fe31, 0x00e2108e,
    0x00e8c210, 0x01149d31, 0x01f08421, 0x0118d771, 0x011cd671, 0x00e8c62e,
    0x0010be2f, 0x01ecc62e, 0x0114be2f, 0x00f8383e, 0x0042109f, 0x00e8c631,
    0x00454631, 0x00aad6b5, 0x01151151, 0x00421151, 0x01f1111f, 0x00e1084e,
    0x01041041, 0x00e4210e, 0x00000144, 0x01f00000, 0x00000082, 0x0164a4c0,
    0x00749c20, 0x00e085c0, 0x00e4b908, 0x0060bd26, 0x0042388c, 0x00c8724c,
    0x00a51842, 0x00420080, 0x00621004, 0x00a32842, 0x00421086, 0x015ab800,
    0x00949800, 0x0064a4c0, 0x0013a4c0, 0x008724c0, 0x00108da0, 0x0064104c,
    0x00c23880, 0x0164a520, 0x00452800, 0x00aad400, 0x00a22800, 0x00111140,
    0x00e221c0, 0x00c2088c, 0x00421084, 0x00622086, 0x000022a2, 
]

def self.draw_letter(screen, x, y, c, color)
  i = c - 32
  return if i < 0 || i >= ShinhFont.size
  d = ShinhFont[i]
  
  5.times do |i|
    5.times do |j|
      next if ((d >> (i * 5 + j)) & 1) == 0
      
      screen[x + j, y + i] = color
    end
  end
end

def self.draw_letter_bold(screen, x, y, c, inner, outer)
  i = c - 32
  return if i < 0 || i >= ShinhFont.size
  d = ShinhFont[i]
  
  5.times do |i|
    5.times do |j|
      next if ((d >> (i * 5 + j)) & 1) == 0
      
      screen[x + j, y + i] = inner
      
      # top
      if i == 0 || ((d >> ((i - 1) * 5 + j)) & 1) == 0
        screen[x + j, y + i - 1] = outer
      end

      # bottom
      if i == 4 || ((d >> ((i + 1) * 5 + j)) & 1) == 0
        screen[x + j, y + i + 1] = outer
      end
      
      # left
      if j == 0 || ((d >> (i * 5 + j - 1)) & 1) == 0
        screen[x + j - 1, y + i] = outer
      end
      
      # right
      if j == 4 || ((d >> (i * 5 + j + 1)) & 1) == 0
        screen[x + j + 1, y + i] = outer
      end
    end
  end
end

# �� #

# ���ʉ���炷
# ���l���w�肷��ƍĐ����~�߂�
#
# �����F
#   playse �t�F�[�h�A�E�g����
#   playse "�t�@�C����"
#   playse "�t�@�C����", ���� (0�`255)
#   playse "�t�@�C����", ���� (0�`255), �p�� (-255�`255)
#
# ��F
#   playse "cluck.wav"
#   playse "dump.ogg"
def playse(name, vol=nil, pan=nil)
  if name.is_a?(Integer)
    StarRuby::Audio.stop_all_ses({ :time => name })
  else
    opt = { :volume => vol || 255, :panning => pan || 0 } if vol || pan
    StarRuby::Audio.play_se name.to_s, opt
  end
end

# BGM��炷
# ���l���w�肷��ƍĐ����~�߂�
#
# �����F
#   playbgm �t�F�[�h�A�E�g���� (�~���b)
#   playbgm "�t�@�C����"
#   playbgm "�t�@�C����", ���� (0�`255)
#   playbgm "�t�@�C����", ���� (0�`255), �t�F�[�h�C������ (�~���b)
#
# ��F
#   playbgm "steelpython.ogg"
#   playbgm "discretemusic.ogg", 50
#   playbgm "landau.ogg", 255, 10000
#   playbgm 1000
def playbgm(name, volume=255, fadein=0)
  if name.is_a?(Integer)
    StarRuby::Audio.stop_bgm({ :time => name })
  else
    opt = { :loop => true, :volume => volume, :time => fadein }
    StarRuby::Audio.play_bgm name.to_s, opt
  end
end

# ���͂Ƃ� #

# �X�y�[�X�L�[
def space?
  key?(:space)
end

# �A���t�@�x�b�g�e��
('a'..'z').each do |c|
  s = c.to_sym
  define_method("#{c}key?") { key? s }
end

# ���
def left?
  key?(:left)
end

def right?
  key?(:right)
end

def up?
  key?(:up)
end

def down?
  key?(:down)
end

def leftmouse?
  key?(:left, :mouse)
end

def rightmouse?
  key?(:left, :mouse)
end

def leftclick?
  click?(:left, :mouse)
end

def rightclick?
  click?(:left, :mouse)
end

def mousex
  mouse[0]
end

def mousey
  mouse[1]
end

# ����Ă�����g���p #

# �}�E�X���W�������؂�Ɏ��o��
# ��: x, y = mouse
def mouse
  StarRuby::Input.mouse_location
end

# �F�����
# ��: yellow = Color(255, 255, 0)
def Color(r, g, b, a=255)
  StarRuby::Color.new(r, g, b, a)
end

# �L�[��������Ă�Œ��Ȃ�true�A�łȂ����false
# ��:
#   if key?(:z)
#     # Z�{�^�������Ă鎞�̏���
#   end
def key?(key, device=:keyboard)
  StarRuby::Input.keys(device).include?(key)
end

# �L�[�������ꂽ�u�ԂȂ�true�A�łȂ����false
# ��:
#   if click?(:left, :mouse)
#     # Z�{�^���������ꂽ�u�Ԃ����̏���
#   end
def click?(key, device=:keyboard)
  new = key?(key, device)
  old = DotGame._click_state([key, device], new)
  old && !new
end

def self._click_state(key, new)
  @_click_state ||= {}
  old = @_click_state[key]
  @_click_state[key] = new
  old
end

# �S��ʈ�C�ɕ`�悷��
# ��:
#   raster do |x, y|
#     if x + y % 2 == 0
#       gray
#     else
#       white
#     end
#   end
def raster(s=StarRuby::Game.current.screen)
  s.height.times do |y|
    s.width.times do |x|
      if color = yield(x, y)
        s[x, y] = color
      end
    end
  end
end

def screen
  StarRuby::Game.current.screen
end

def screenw
  screen.width
end

def screenh
  screen.height
end

# �{�� #
def main(w=20, h=20, title="", fps=30)
  bg = StarRuby::Texture.new(w, h)
  bg.fill(white)
  raster(bg) do |x,y|
    bg[x, y] = gray if (x + y).odd?
  end
  StarRuby::Game.run(w, h, { :title => title, :window_scale => [600.0 / [w, h].max, 1].max, :cursor => true, :fps => fps }) do |game|
    keys = StarRuby::Input.keys(:keyboard)
    if keys.include?(:plus)
      game.window_scale += 1
    elsif keys.include?(:minus)
      game.window_scale -= 1
    elsif keys.include?(:f11) || keys.include?(:enter) && (keys.include?(:lmenu) || keys.include?(:rmenu))
      game.fullscreen = !game.fullscreen?
    end
    game.screen.render_texture(bg, 0, 0)
    yield game
  end
end

# int main() { ... } �݂����ɏ�����悤�ɂ���_�~�[�֐�
def int(*)
  warn ":p"
end

end # module DotGame

if __FILE__ == $0
  unless File.exist?('main.txt')
    open('main.txt', 'w') do |f|
      f.puts 'main() {'
      f.puts '  text "HOGE"'
      f.puts '}'
    end
  end
    
  include DotGame
  load 'main.txt'
end
