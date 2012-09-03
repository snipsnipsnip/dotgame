# dotgame: starruby for dummies
# https://gist.github.com/962107

require 'starruby'
require 'kconv'
require 'dotgame/dotfont'

module DotGame

VERSION = "0.0.7"

include Math

# 色 #

def self.define_color(name, r, g=nil, b=nil, a=255)
  color = r.is_a?(StarRuby::Color) ? r : StarRuby::Color.new(r, g || r, b || r, a)
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

# 描画 #

module DrawingAliases

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
def dot(x, y, r=0, g=nil, b=nil, a=255)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  render_pixel x, y, color
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
def line(x1, y1, x2, y2, r=0, g=nil, b=nil, a=255)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  render_line x1, y1, x2, y2, color
end

# 四角形を書く
#
# 書式：
#   square 左上のX座標, 左上のY座標, 横幅, 縦幅
#
# 例：
#   square 10, 10, 5, 5, blue
def square(x, y, w, h, r=0, g=nil, b=nil, a=255)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  render_rect x, y, w, h, color
end

# ぬりつぶし
#
# 書式：
#   bucket 色の名前 (red, blue, green..)
#   bucket 色の濃さ (0～255)
#   bucket R, G, B
#
# 例：
#   bucket white
def bucket(r=0, g=nil, b=nil, a=255)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  fill(color)
end

# 画像を張り付ける
# フォルダ越しに指定する場合 \ ではなく / を使うこと
#
# 書式：
#   image "ファイル名"
#   image "ファイル名", 左上のX座標, 左上のY座標
#   image "ファイル名", 左上のX座標, 左上のY座標, 倍率
#   image "ファイル名", 左上のX座標, 左上のY座標, {オプション}
#   
# 例：
#   image "neko.bmp"
#   image "c:/tree.gif", 5, 5
#   image "c:/face.png", 3, 3, 2
def image(name, x=0, y=0, scale=nil)
  if t = DotGame.get_texture(name)
    opt = scale.is_a?(Hash) ? scale : { :scale_x => scale, :scale_y => scale } if scale
    render_texture t, x, y, opt
  end
end

# 英数字を書く
#
# 書式：
#   text 変数名
#   text 数値
#   text "メッセージ"
#   text "メッセージ", 左上のX座標, 左上のY座標
#   text "メッセージ", 左上のX座標, 左上のY座標, 倍率
#   text "メッセージ", 左上のX座標, 左上のY座標, 倍率, 色の名前 (red, blue, green..)
#   text "メッセージ", 左上のX座標, 左上のY座標, 倍率, 色の濃さ (0～255)
#   text "メッセージ", 左上のX座標, 左上のY座標, 倍率, R, G, B
#
# 例：
#   text 100
#   text "hoge"
#   text "hoge", 5, 5
def text(msg, x=0, y=0, scale=1, r=0, g=nil, b=nil, a=255)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  ix = x
  msg.to_s.each_byte do |c|
    if c == 10
      x = ix
      y += 5 * scale + 1
    else
      c -= 32
      ShinhFont.draw_letter(self, x, y, c, scale, color)
      x += 5 * scale + 1
    end
  end
end

# フチつきtext
def textbold(msg, x=0, y=0, scale=1, inner=white, outer=black)
  x += 1
  y += 1
  ix = x
  msg.to_s.each_byte do |c|
    if c == 10
      x = ix
      y += 6 * scale + 1
    else
      c -= 32
      ShinhFont.draw_letter(self, x + 1, y, c, scale, outer)
      ShinhFont.draw_letter(self, x - 1, y, c, scale, outer)
      ShinhFont.draw_letter(self, x, y + 1, c, scale, outer)
      ShinhFont.draw_letter(self, x, y - 1, c, scale, outer)
      ShinhFont.draw_letter(self, x, y, c, scale, inner)
      x += 7 * scale + 1
    end
  end
end

# 5x5 bitmap font by shinh (http://d.hatena.ne.jp/shinichiro_h/20060814#1155567183)
# Licensed under the New BSD License.
ShinhFont = DotFont.new [
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

# 全画面一気に描画する
# 例:
#   raster do |x, y|
#     if x + y % 2 == 0
#       gray
#     else
#       white
#     end
#   end
def raster
  height.times do |y|
    width.times do |x|
      if color = yield(x, y)
        self[x, y] = color
      end
    end
  end
end

end # module DrawingAliases

StarRuby::Texture.module_eval do
  include DrawingAliases
end

DrawingAliases.instance_methods.each do |name|
  game = StarRuby::Game
  define_method(name) do |*args|
    game.current.screen.__send__(name, *args)
  end
end

def imagew(name)
  if t = DotGame.get_texture(name)
    t.width
  end
end

def imageh(name)
  if t = DotGame.get_texture(name)
    t.height
  end
end

def self.get_texture(name)
  return name if name.is_a?(StarRuby::Texture)
  @_textures[name] ||= StarRuby::Texture.load(name.to_s)
rescue
  warn "\211\346\221\234 '#{name}' \202\252\223\307\202\335\215\236\202\337\202\334\202\271\202\361\202\305\202\265\202\275"
  nil
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

# アルファベット各種
[:space, :left, :right, :up, :down, *'a'..'z'].each do |c|
  s = c.to_sym
  define_method("#{c}?") { key? s }
  define_method("#{c}release?") { release? s }
end

# マウス
[:left, :right, :middle].each do |c|
  define_method("#{c}mouse?") { key?(c, :mouse) }
  define_method("#{c}click?") { release?(c, :mouse) }
end

# ゲームパッド
(0..5).each do |n|
  device = [:gamepad, {:device_number => [0, n - 1].max}]
  name = n == 0 ? '' : n.to_s
  
  [:left, :right, :up, :down].each do |c|
    define_method("pad#{name}#{c}?") { key?(c, device) }
    define_method("pad#{name}#{c}release?") { release?(c, device) }
  end
  
  ("a".."z").each_with_index do |c, i|
    button = i + 1
    define_method("pad#{name}#{c}?") { key?(button, device) }
    define_method("pad#{name}#{c}release?") { release?(button, device) }
  end
end

def mousex
  mouse[0]
end

def mousey
  mouse[1]
end

# 慣れてきたら使う用 #

# 再起動
def self.reload
  throw :dotgame_reload, :dotgame_reload
end

# 起動からのミリ秒
def time
  StarRuby::Game.ticks
end

# タイトルバーの文字列を設定
def title(t)
  StarRuby::Game.current.title = (t.is_a?(String) ? t : t.inspect).toutf8
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
  DotGame.pressed?(key, device)
end

# キーが放された瞬間ならtrue、でなければfalse
# 例:
#   if release?(:z, :mouse)
#     # Zボタンが離された瞬間だけの処理
#   end
def release?(key, device=:keyboard)
  DotGame.released?(key, device)
end

def self.swap_keys
  @keys, @keys_prev = @keys_prev, @keys
  @keys.each_key {|k| @keys[k] = StarRuby::Input.keys(*k) }
end

def self.pressed?(key, device)
  @keys[device].include?(key)
end

def self.released?(key, device)
  @keys_prev[device].include?(key) && !@keys[device].include?(key)
end


def screenw
  screen.width
end

def screenh
  screen.height
end

def window_scale
  StarRuby::Game.current.window_scale
end

def window_scale=(s)
  StarRuby::Game.current.window_scale = s
end

def make_texture(*args)
  StarRuby::Texture.new(*args)
end

def self.init
  @_textures = {}
  @keys = {:keyboard => [], :mouse => []}
  StarRuby::Input.gamepad_count.times {|i| @keys[[:gamepad, {:device_number => i}]] = [] }
  @keys_prev = @keys.dup
end


def self._make_checkerboard(w, h)
  bg = make_texture(w, h)
  bg.fill(white)
  bg.raster {|x,y| (x + y).odd? ? gray : white }
  bg
end

# 本体 #
def main(w=20, h=20, fps=30, title=nil, bg=DotGame._make_checkerboard(w, h))
  DotGame.init
  
  if title
    title = title.to_s.toutf8
  else
    title = "F5キーでリロード - dotgame v#{DotGame::VERSION}"
  end
  
  opts = {
    :title => title,
    :window_scale => [600.0 / [w, h].max, 1].max,
    :cursor => true,
    :fps => fps
  }
  
  StarRuby::Game.run(w, h, opts) do |game|
    DotGame.swap_keys
    if release?(:add)
      game.window_scale += 1
    elsif release?(:subtract)
      game.window_scale -= 1
    elsif release?(:f11) || release?(:enter) && (key?(:lmenu) || key?(:rmenu))
      game.fullscreen = !game.fullscreen?
    elsif release?(:f5)
      DotGame.reload
    elsif release?(:escape)
      break
    end
    game.screen.render_texture(bg, 0, 0) if bg
    yield game
  end
end

# int main() { ... } みたいに書けるようにするダミー関数
def int(*)
  warn ":p"
end

end # module DotGame

if __FILE__ == $0
  script = (ARGV + %w[main.rb main.txt]).find {|x| x && File.exist?(x) }
  
  unless script
    script = 'main.txt'
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
    system "start #{script}"
  end

  include DotGame
  
  begin
    r = catch(:dotgame_reload) do
      load script, true
      nil
    end
  rescue Interrupt
    r = nil
  rescue Exception => e
    puts "\203G\203\211\201[\203\201\203b\203Z\201[\203W:\n  #{e}"
    puts "\203G\203\211\201[\202\314\216\355\227\336:\n  #{e.class}"
    puts "\214\304\202\321\217o\202\265\227\232\227\360:", e.backtrace[0..-5].map {|x| "  #{x}" }
    r = true
    puts "\203\212\203^\201[\203\223\202\360\211\237\202\267\202\306\215\304\212J\202\265\202\334\202\267"
    STDIN.gets
  end while r
end
