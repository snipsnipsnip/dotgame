module DotGame
  # 入力
  module Input
    # アルファベット各種
    [:space, :enter, :escape, :separator, :left, :right, :up, :down, *'a'..'z'].each do |c|
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
    
    # マウス座標をいっぺんに取り出す
    # 例: x, y = mouse
    def mouse
      StarRuby::Input.mouse_location
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
  end
end
