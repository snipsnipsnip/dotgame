# dotgame: starruby for dummies
# https://gist.github.com/962107

require 'starruby'

module DotGame

VERSION = "0.0.5"

include Math

# 色 #

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

# 描画 #

# 点を打つ
#
# 書式：
#   dot X座標, Y座標
#   dot X座標, Y座標, 色の名前 (red, blue, green..)
#   dot X座標, Y座標, 色の濃さ (0～255)
#   dot X座標, Y座標, R, G, B
#
# 例：
#   dot 10, 10
#   dot 3, 3
#   dot 10, 10, 50
#   dot 10, 10, 50, 200, 50
def dot(x, y, r=0, g=nil, b=nil, a=255, s=StarRuby::Game.current.screen)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  s.render_pixel x, y, color
end

# 線を引く
#
# 書式：
#   line もとのX座標, もとのY座標, 先のX座標, 先のY座標
#   line もとのX座標, もとのY座標, 先のX座標, 先のY座標
#   line もとのX座標, もとのY座標, 先のX座標, 先のY座標, 色の名前 (red, blue, green..)
#   line もとのX座標, もとのY座標, 先のX座標, 先のY座標, 色の濃さ (0～255)
#   line もとのX座標, もとのY座標, 先のX座標, 先のY座標, R, G, B
#
# 例：
#   line 10, 10, 50, 200, red
def line(x1, y1, x2, y2, r=0, g=nil, b=nil, a=255, s=StarRuby::Game.current.screen)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  s.render_line x1, y1, x2, y2, color
end

# 線を引く
#
# 書式：
#   square 左上のX座標, 左上のY座標, 横幅, 縦幅
#
# 例：
#   square 10, 10, 5, 5, blue
def square(x, y, w, h, r=0, g=nil, b=nil, a=255, s=StarRuby::Game.current.screen)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  s.render_rect x, y, w, h, color
end

# 画像を張り付ける
# フォルダ越しに指定する場合 \ ではなく / を使うこと
#
# 書式：
#   image "ファイル名"
#   image "ファイル名", 左上のX座標, 左上のY座標
#   image "ファイル名", 左上のX座標, 左上のY座標, 倍率
#
# 例：
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

def imagew(name)
  if t = name.is_a?(String) ? DotGame.get_texture(name) : name
    t.width
  else
    warn "\211\346\221\234 '#{name}' \202\252\223\307\202\335\215\236\202\337\202\334\202\271\202\361\202\305\202\265\202\275"
  end
end

def imageh(name)
  if t = name.is_a?(String) ? DotGame.get_texture(name) : name
    t.width
  else
    warn "\211\346\221\234 '#{name}' \202\252\223\307\202\335\215\236\202\337\202\334\202\271\202\361\202\305\202\265\202\275"
  end
end

def self.get_texture(name)
  @_textures ||= {}
  @_textures[name] ||= StarRuby::Texture.load(name)
end

# 英数字を書く
#
# 書式：
#   text 変数名
#   text 数値
#   text "メッセージ"
#   text "メッセージ", 左上のX座標, 左上のY座標
#   text "メッセージ", 左上のX座標, 左上のY座標, 色の名前 (red, blue, green..)
#   text "メッセージ", 左上のX座標, 左上のY座標, 色の濃さ (0～255)
#   text "メッセージ", 左上のX座標, 左上のY座標, R, G, B
#
# 例：
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

# フチつきtext
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

# 音 #

# 効果音を鳴らす
# 数値を指定すると再生を止める
#
# 書式：
#   playse フェードアウト時間
#   playse "ファイル名"
#   playse "ファイル名", 音量 (0～255)
#   playse "ファイル名", 音量 (0～255), パン (-255～255)
#
# 例：
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

# BGMを鳴らす
# 数値を指定すると再生を止める
#
# 書式：
#   playbgm フェードアウト時間 (ミリ秒)
#   playbgm "ファイル名"
#   playbgm "ファイル名", 音量 (0～255)
#   playbgm "ファイル名", 音量 (0～255), フェードイン時間 (ミリ秒)
#
# 例：
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

# 入力とか #

# スペースキー
def space?
  key?(:space)
end

# アルファベット各種
('a'..'z').each do |c|
  s = c.to_sym
  define_method("#{c}key?") { key? s }
end

# 矢印
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

# 慣れてきたら使う用 #

# 再起動
def reload
  throw :dotgame_reload, true
end

# 起動からのミリ秒
def time
  StarRuby::Game.current.ticks
end

# マウス座標をいっぺんに取り出す
# 例: x, y = mouse
def mouse
  StarRuby::Input.mouse_location
end

# 色を作る
# 例: yellow = Color(255, 255, 0)
def Color(r, g, b, a=255)
  StarRuby::Color.new(r, g, b, a)
end

# キーが押されてる最中ならtrue、でなければfalse
# 例:
#   if key?(:z)
#     # Zボタン押してる時の処理
#   end
def key?(key, device=:keyboard)
  StarRuby::Input.keys(device).include?(key)
end

# キーが放された瞬間ならtrue、でなければfalse
# 例:
#   if click?(:left, :mouse)
#     # Zボタンが離された瞬間だけの処理
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

# 全画面一気に描画する
# 例:
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

# 本体 #
def main(w=20, h=20, fps=30, title="F5キーでリロード - dotgame v#{DotGame::VERSION}")
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
    elsif keys.include?(:f5)
      reload
    elsif keys.include?(:escape)
      break
    end
    game.screen.render_texture(bg, 0, 0)
    yield game
  end
end

# int main() { ... } みたいに書けるようにするダミー関数
def int(*)
  warn ":p"
end

end # module DotGame

if __FILE__ == $0
  script = 'main.txt'
  
  if !File.exist?(script)
    open(script, 'w') do |f|
      f.puts "# dotgame v#{DotGame::VERSION}"
      f.puts "# https://gist.github.com/962107"
      f.puts
      f.puts 'main() {'
      f.puts '  text "HOGE"'
      f.puts '  dot 5, 10'
      f.puts '  dot 10, 10, red'
      f.puts '  dot 15, 10'
      f.puts '}'
    end
  end
  
  system "start #{script}"
  
  begin
    r = catch(:dotgame_reload) do
      include DotGame
      load script
      nil
    end
  end while r
end
