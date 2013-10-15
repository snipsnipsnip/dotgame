module DotGame
  # 入力
  module Input
    def self.define_module_function(name, *argv, &blk)
      define_method(name, *argv, &blk)
      module_function name
    end
    
    # @!group キーボード
    
    [:space, :escape, :enter, :left, :right, :up, :down, *'a'..'z'].each do |c|
      s = c.to_sym
      define_module_function("#{c}?") { key? s }
      define_module_function("#{c}release?") { release? s }
    end
    
    # @!endgroup

    # @!group マウス
    
    [:left, :right, :middle].each do |c|
      define_module_function("#{c}mouse?") { key?(c, :mouse) }
      define_module_function("#{c}click?") { release?(c, :mouse) }
    end
    
    # @!endgroup

    # @!group ゲームパッド
    
    (0..5).each do |n|
      device = [:gamepad, {:device_number => [0, n - 1].max}]
      name = n == 0 ? '' : n.to_s
      
      [:left, :right, :up, :down].each do |c|
        define_module_function("pad#{name}#{c}?") { key?(c, device) }
        define_module_function("pad#{name}#{c}release?") { release?(c, device) }
      end
      
      ("a".."z").each_with_index do |c, i|
        button = i + 1
        define_module_function("pad#{name}#{c}?") { key?(button, device) }
        define_module_function("pad#{name}#{c}release?") { release?(button, device) }
      end
    end
    
    # @!endgroup

    module_function
    
    # @!group マウス
    
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
    
    # @!endgroup
    
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
