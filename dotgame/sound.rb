module DotGame
  # 音
  module Sound
    module_function
  
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
  end
end
