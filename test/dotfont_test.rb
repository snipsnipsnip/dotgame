require 'test_helper'
require 'dotgame/dotfont'

class DotFontTest < Test::Unit::TestCase
  context "draw_letter" do
    context "with []" do
      subject { DotGame::DotFont.new([]) }
      should "fail" do
        assert_raise(IndexError) do
          subject.draw_letter(stub, stub, stub, 0, stub, stub)
        end
      end
    end
    
    context "with [0]" do
      subject { DotGame::DotFont.new([0]) }
      
      should "fail on index other than 0" do
        assert_raise(IndexError) do
          subject.draw_letter(stub, stub, stub, -1, stub, stub)
        end
        
        assert_raise(IndexError) do
          subject.draw_letter(stub, stub, stub, 1, stub, stub)
        end
      end
      
      should "work on index 0" do
        screen = mock(:screen)
        x = stub(:x)
        y = stub(:y)
        scale = stub(:scale)
        color = stub(:color, :red => stub, :blue => stub, :green => stub)
        transparent = mock(:transparent)
        tex = mock(:cache_texture)
        black = mock(:black)
        
        tex.expects(:fill).with(transparent)
        subject.expects(:make_texture).with(5, 5).returns(tex)
        subject.expects(:transparent).returns(transparent)
        subject.expects(:black).returns(black)
        
        screen.expects(:render_texture).with do |*params|
          expected_opts = {
            :scale_x => scale,
            :scale_y => scale,
            :tone_red => color.red,
            :tone_green => color.green,
            :tone_blue => color.blue,
          }
          opts = params[3]
          
          params.size == 4 and
          [tex, x, y].zip(params).all? {|x, y| x.equal? y } and
          expected_opts.all? {|k,v| opts[k].equal?(v) }
        end
        
        subject.draw_letter(screen, x, y, 0, scale, color)
      end
    end
  end
end
