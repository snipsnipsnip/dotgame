
=begin

参考： http://www.nintendo.co.jp/3ds/asrj/movie/movie.html?mov=3back

ゆっくり2バック：24問0:28～1:22 = 54秒かかった (制限時間なし？) 85％以上でクリア
ゆっくり3バック：26問を3:30～4:46 = 76秒かかった 65%以上でクリア？
ゆっくり5バック：30問

mバックは20+2m問出るのかね

要するに計算・エンキュー・デキューの手順でやればいいんだな
数字書いて解答したら問題が進んじゃうから先にエンキューする必要がある
nバックにはn+1個ワークスペースが必要になる
数字を言いながら計算

nバックでは、m番目の問題を見ながら(n-m)番目の問題に答える
問題は上から流れてくる
each_consみたいな感じだな

problem = { (a, op, b, a op b) | op ∈ {+, -}, 0 <= a, b, a op b <= 9 }
answer = タイムアップ or パス or 数字

=end

class ProblemQueue
  def initialize(back)
    @back = back
    @q = []
    @problems = enum_for(:each_problem).to_a
    @y = 0
    @answer = nil
  end
  
  def tick
    if @y != 0
      @y = @y + 1
      
      if @y == 7
        @q.pop unless @q.size < @back + 3
        @q.unshift rand(@problems.size)
        @y = 0
      end
    end
  end
  
  def draw
    y = @y - 5
    current = @back + (@y == 0 ? 1 : 0)
    
    @q.each_with_index do |problem_number, i|
      if i == current
        text "???=", 1, y + i * 6, 1, blue
      elsif i == current + 1 || i == current + 2
        answer = i == current + 1 ? @answer : @prevanswer
        problem = @problems[problem_number]
        color = problem[3] == answer ? Color(0, 200, 0) : red
        text "#{problem[0..2]}=#{problem[3]}", 1, y + i * 6, 1, color
      else
        problem = @problems[problem_number]
        text "#{problem[0..2]}=", 1, y + i * 6, 1, black
      end
    end
  end
  
  def shift(answer)
    return if @y != 0
    
    @y += 1 
    @prevanwer = @answer
    @answer = answer
    
    current_problem = @problems[@back + 1]
    current_problem[3] == answer
  end
  
  private
  def each_problem
    [:+, :-].each do |op|
      (0..9).each do |a|
        (0..9).each do |b|
          c = a.__send__(op, b)
          if 0 <= c && c <= 9
            yield a, op, b, c
          end
        end
      end
    end
  end
end

def make_numkeys
  numkeys = (0..9).map {|d| [:"numpad#{d}", :"d#{d}"] }
  
  def numkeys.get_pressed
    each_with_index {|v, i| return i if release?(v[0]) || release?(v[1]) }
    nil
  end
  
  numkeys
end

back = 1
queue = ProblemQueue.new(back)
numkeys = make_numkeys

total_count = 0
correct_count = 0

main(31, (back + 2) * 6 + 1, 30) {
  queue.tick
  queue.draw
  
  square 0, 7, screenw, screenh - 7 * 3 + 1, white
  
  if answer = numkeys.get_pressed
    title "%d / %d (%.0f%%)" % [correct_count, total_count, correct_count / total_count.to_f * 100]
    correct_count += 1 if queue.shift(answer)
    total_count += 1
  end
}

#main(400, 400, 30, {:background => nil}) {
#  image(t ||= tex(w, h))
#}
