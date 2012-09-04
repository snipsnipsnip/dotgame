require 'test_helper'
require 'dotgame/draw'

class DrawTest < Test::Unit::TestCase
  context "draw" do
    subject do
      subj = stub("subject")
      class << subj
        include DotGame::Draw
        public *DotGame::Draw.instance_methods
        
        def Color(r, g, b, a)
          raise "stub me"
        end
      end
      subj
    end
    
    context "text" do
      should "accept 1 argument" do
        font = DotGame::DotFont.any_instance
        black = stub("black")
        
        called = []
        font.stubs(:draw_letter).with {|*args| called << args }.times(4)
        subject.stubs(:Color).with(0, 0, 0, 255).returns(black)
        
        subject.text "hoge"
        
        called.each_with_index do |(screen, x, y, char, scale, color), i|
          assert_equal subject, screen
          assert_equal 6 * i, x
          assert_equal 0, y
          assert_equal "hoge"[i] - 32, char
          assert_equal 1, scale
          assert_equal black, color
        end
      end
    end
  end
end
