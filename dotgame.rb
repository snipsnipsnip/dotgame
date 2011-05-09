# dotgame r2
# https://gist.github.com/962107

require 'starruby'

module DotGame

VERSION = "0.0.2"

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
#   square もとのX座標, もとのY座標, 横幅, 縦幅
#
# 例：
#   square 10, 10, 5, 5, blue
def square(x, y, w, h, r=0, g=nil, b=nil, a=255, s=StarRuby::Game.current.screen)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  s.render_rect x, y, w, h, color
end

# 入力とか #

# スペースキー
def space?
  key?(:space)
end

# アルファベット各種
def zkey?
  key?(:z)
end

def xkey?
  key?(:x)
end

def ckey?
  key?(:c)
end

def vkey?
  key?(:v)
end

def akey?
  key?(:a)
end

def skey?
  key?(:s)
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

def main(fps=30, w=20, h=20)
  bg = StarRuby::Texture.new(w, h)
  raster(bg) do |x,y|
    bg[x, y] = (x + y).odd? ? white : gray
  end
  StarRuby::Game.run(w, h, :window_scale => [600 / [w, h].min, 1].max, :cursor => true, :fps => fps) do |game|
    game.screen.render_texture(bg, 0, 0)
    yield
  end
end

end

if __FILE__ == $0
  if File.exist?('main.txt')
    include DotGame
    load 'main.txt'
  else
    require 'Win32API'
    Win32API.new('user32', 'MessageBox', %w(p p p i), 'i').call(0, "\202\261\202\314\203t\203@\203C\203\213\202\306\223\257\202\266\202\306\202\261\202\353\202\311main.txt\202\360\222u\202\242\202\304\202\255\202\276\202\263\202\242\n\223\340\227e\202\315\210\310\211\272\202\314\222\312\202\350\202\305\202\267\n\nmain() {\n}\n\n\217\332\202\265\202\242\211\360\220\340\202\315\210\310\211\272\202\314\203T\203C\203g\202\305\202\307\202\244\202\274\n  http://m-creator.vbl.oita-u.ac.jp/kodama/moin/dotgame/\n", "dotgame", 0)
  end
end
