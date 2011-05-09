# dotgame r1

require 'starruby'

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
def dot(x, y, r=0, g=nil, b=nil, a=255)
  color = r.is_a?(StarRuby::Color) ? r : Color(r, g || r, b || r, a)
  StarRuby::Game.current.screen[x, y] = color
end

# 入力とか #

# スペースキー
def space
  key?(:space)
end

# アルファベット各種
def zkey
  key?(:z)
end

def xkey
  key?(:x)
end

def ckey
  key?(:c)
end

def vkey
  key?(:v)
end

def akey
  key?(:a)
end

def skey
  key?(:s)
end

# 矢印
def left
  key?(:left)
end

def right
  key?(:right)
end

def up
  key?(:up)
end

def down
  key?(:down)
end

def leftclick
  key?(:left, :mouse)
end

def rightclick
  key?(:left, :mouse)
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

# キーを調べる
# 例:
#   if key?(:z)
#     # Zボタン押してる時の処理
#   end
def key?(key, device=:keyboard)
  StarRuby::Input.keys(device).include?(key)
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

def self.main(fps=10, w=20, h=20)
  StarRuby::Game.run(w, h, :window_scale => [w, h].max * 30 / 20, :cursor => true, :fps => fps) do |game|
    raster(game.screen) do |x,y|
      dot x, y, (x + y).odd? ? white : gray
    end
    yield
  end
end

if __FILE__ == $0
  if File.exist?('main.txt')
    include Math
    load 'main.txt'
  else
    require 'Win32API'
    Win32API.new('user32', 'MessageBox', %w(p p p i), 'i').call(0, <<EOS, "dotgame", 0)
このファイルと同じところにmain.txtを置いてください
内容は以下の通りです

main() {
}

詳しい解説は以下のサイトでどうぞ
  http://m-creator.vbl.oita-u.ac.jp/kodama/moin/dotgame/
EOS
  end
end
