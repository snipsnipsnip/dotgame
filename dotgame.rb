# dotgame: starruby for dummies
# https://gist.github.com/962107

require 'starruby'
require 'kconv'
require 'dotgame/dotfont'
require 'dotgame/colors'
require 'dotgame/draw'
require 'dotgame/sound'
require 'dotgame/input'

module DotGame

VERSION = "0.0.7"

StarRuby::Texture.module_eval do
  include Draw
end

Draw.instance_methods.each do |name|
  game = StarRuby::Game
  define_method(name) do |*args|
    game.current.screen.__send__(name, *args)
  end
end

# 画像の横幅を調べる。
def imagew(name)
  t = DotGame.get_texture(name) and t.width
end

# 画像の縦幅を調べる。
def imageh(name)
  t = DotGame.get_texture(name) and t.height
end

def self.get_texture(name)
  return name if name.is_a?(StarRuby::Texture)
  @_textures[name] ||= StarRuby::Texture.load(name.to_s)
rescue
  warn "\211\346\221\234 '#{name}' \202\252\223\307\202\335\215\236\202\337\202\334\202\271\202\361\202\305\202\265\202\275"
  nil
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

def self.init(w=20, h=20, fps=30, opts=nil, &blk)
  opts ||= {}
  opts[:window_scale] ||= [600.0 / [w, h].max, 1].max
  opts[:fps] ||= fps
  opts[:width] ||= w
  opts[:height] ||= h
  
  @_textures = {}
  @keys = {:keyboard => [], :mouse => []}
  StarRuby::Input.gamepad_count.times {|i| @keys[[:gamepad, {:device_number => i}]] = [] }
  @keys_prev = @keys.dup
  @options = opts
  @main = blk
  
  raise ArgumentError, "main \202\314\202\240\202\306\202\311 {} \202\252\202\240\202\350\202\334\202\271\202\361" unless blk
end

def self.run
  opts = @options.dup
  opts[:cursor] = true unless opts.key?(:cursor)
  title = opts[:title] || "F5キーでリロード - dotgame v#{DotGame::VERSION}"
  title = title.to_s.toutf8
  w, h = opts.values_at(:width, :height)
  bg = opts[:background] || DotGame._make_checkerboard(w, h) unless opts.key?(:bg)
  main = @main
  
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
    main.call(game)
  end
end

def self._make_checkerboard(w, h)
  bg = make_texture(w, h)
  bg.fill(white)
  bg.raster {|x,y| (x + y).odd? ? gray : white }
  bg
end

# 本体 #
def main(*args, &blk)
  DotGame.init(*args, &blk)
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

  include Math
  include DotGame
  include DotGame::Colors
  include DotGame::Sound
  include DotGame::Input
  
  begin
    r = catch(:dotgame_reload) do
      load script, true
      DotGame.run
      nil
    end
  rescue Interrupt
    r = nil
  rescue Exception => e
    puts "\203G\203\211\201[\203\201\203b\203Z\201[\203W:\n  #{e}"
    puts "\203G\203\211\201[\202\314\216\355\227\336:\n  #{e.class}"
    puts "\214\304\202\321\217o\202\265\227\232\227\360:"
    puts e.backtrace.take_while {|x| x !~ /dotgame\.rb:\d+:in `(?:run_main_loop|call)'/ }.map {|x| "  #{x}" }
    r = true
    puts "\203\212\203^\201[\203\223\202\360\211\237\202\267\202\306\215\304\212J\202\265\202\334\202\267"
    STDIN.gets
  end while r
end
