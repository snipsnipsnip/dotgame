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
      setup do
        @draw_letter_calls = []
        @any_font = DotGame::DotFont.any_instance
        @any_font.stubs(:draw_letter).with {|*args| @draw_letter_calls << args }
        @color = stub("color")
        subject.stubs(:Color).with(0, 0, 0, 255).returns(@color)
      end
      
      teardown do
        @any_font.unstub(:draw_letter)
      end
    
      args = ["hoge", 0, 0, 1, 0, 0, 0, 255]
      
      args.each_index do |i|
        should "accept #{i + 1} argument(s)" do
          subject.text *args[0..i]
          
          assert_equal 4, @draw_letter_calls.size
          @draw_letter_calls.each_with_index.zip("hoge".bytes) do |((screen, x, y, char, scale, color), i), b|
            assert_equal subject, screen
            assert_equal 6 * i, x
            assert_equal 0, y
            assert_equal b - 32, char
            assert_equal 1, scale
            assert_equal @color, color
          end
        end
      end
    end
  end
end
