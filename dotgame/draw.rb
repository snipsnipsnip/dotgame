require 'dotgame/dotfont'

module DotGame
  # 描画
  # mix-in for StarRuby::Texture
  module Draw
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
    def dot(x, y, r=0, g=r, b=r, a=255)
      render_pixel x, y, Color(r, g, b, a)
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
    def line(x1, y1, x2, y2, r=0, g=r, b=r, a=255)
      render_line x1, y1, x2, y2, Color(r, g, b, a)
    end

    # 四角形を書く
    #
    # 書式：
    #   square 左上のX座標, 左上のY座標, 横幅, 縦幅
    #
    # 例：
    #   square 10, 10, 5, 5, blue
    def square(x, y, w, h, r=0, g=r, b=r, a=255)
      render_rect x, y, w, h, Color(r, g, b, a)
    end

    # ぬりつぶし
    #
    # 書式：
    #   bucket 色の名前 (red, blue, green..)
    #   bucket 色の濃さ (0～255)
    #   bucket R, G, B
    #
    # 例：
    #   bucket white
    def bucket(r=0, g=r, b=r, a=255)
      fill Color(r, g, b, a)
    end

    # 画像を張り付ける
    # フォルダ越しに指定する場合 \ ではなく / を使うこと
    #
    # 書式：
    #   image "ファイル名"
    #   image "ファイル名", 左上のX座標, 左上のY座標
    #   image "ファイル名", 左上のX座標, 左上のY座標, 倍率
    #   image "ファイル名", 左上のX座標, 左上のY座標, 横倍率, 縦倍率
    #   image "ファイル名", 左上のX座標, 左上のY座標, {オプション}
    #   
    # 例：
    #   image "neko.bmp"
    #   image "c:/tree.gif", 5, 5
    #   image "c:/face.png", 3, 3, 2
    def image(name, x=0, y=0, scale_x=nil, scale_y=scale_x)
      t = DotGame.get_texture(name) or return
      if scale_x
        if scale_x.is_a?(Hash)
          opt = scale_x
        else
          opt = { :scale_x => scale_x, :scale_y => scale_y }
        end
      end
      render_texture t, x, y, opt
    end

    # 画像を張り付ける
    # フォルダ越しに指定する場合 \ ではなく / を使うこと
    #
    # 書式：
    #   image3d "ファイル名", {オプション}
    #   
    # 例：
    #   image3d "neko.bmp", {:blur => :background, :camera_height => 5}
    def image3d(name, opt)
      t = DotGame.get_texture(name) or return
      render_in_perspective t, opt
    end

    # 英数字を書く
    #
    # 書式：
    #   text 変数名
    #   text 数値
    #   text "メッセージ"
    #   text "メッセージ", 左上のX座標, 左上のY座標
    #   text "メッセージ", 左上のX座標, 左上のY座標, 倍率
    #   text "メッセージ", 左上のX座標, 左上のY座標, 倍率, 色の名前 (red, blue, green..)
    #   text "メッセージ", 左上のX座標, 左上のY座標, 倍率, 色の濃さ (0～255)
    #   text "メッセージ", 左上のX座標, 左上のY座標, 倍率, R, G, B
    #
    # 例：
    #   text 100
    #   text "hoge"
    #   text "hoge", 5, 5
    def text(msg, x=0, y=0, scale=1, r=0, g=r, b=r, a=255)
      color = Color(r, g, b, a)
      ShinhFont.draw_text(self, x, y, msg, scale, color)
    end

    # フチつきtext
    def textbold(msg, x=0, y=0, scale=1, inner=white, outer=black)
      ShinhFont.draw_text_bold(self, x, y, msg, scale, inner_outer)
    end

    # 5x5 bitmap font by shinh (http://d.hatena.ne.jp/shinichiro_h/20060814#1155567183)
    # Licensed under the New BSD License.
    ShinhFont = DotFont.new [
        0x00000000, 0x00401084, 0x0000014a, 0x00afabea, 0x01fa7cbf, 0x01111111,
        0x0126c8a2, 0x00000084, 0x00821088, 0x00221082, 0x015711d5, 0x00427c84,
        0x00220000, 0x00007c00, 0x00400000, 0x00111110, 0x00e9d72e, 0x00421084,
        0x01f2222e, 0x00e8b22e, 0x008fa54c, 0x01f87c3f, 0x00e8bc2e, 0x0042221f,
        0x00e8ba2e, 0x00e87a2e, 0x00020080, 0x00220080, 0x00820888, 0x000f83e0,
        0x00222082, 0x0042222e, 0x00ead72e, 0x011fc544, 0x00f8be2f, 0x00e8862e,
        0x00f8c62f, 0x01f0fc3f, 0x0010bc3f, 0x00e8e42e, 0x0118fe31, 0x00e2108e,
        0x00e8c210, 0x01149d31, 0x01f08421, 0x0118d771, 0x011cd671, 0x00e8c62e,
        0x0010be2f, 0x01ecc62e, 0x0114be2f, 0x00f8383e, 0x0042109f, 0x00e8c631,
        0x00454631, 0x00aad6b5, 0x01151151, 0x00421151, 0x01f1111f, 0x00e1084e,
        0x01041041, 0x00e4210e, 0x00000144, 0x01f00000, 0x00000082, 0x0164a4c0,
        0x00749c20, 0x00e085c0, 0x00e4b908, 0x0060bd26, 0x0042388c, 0x00c8724c,
        0x00a51842, 0x00420080, 0x00621004, 0x00a32842, 0x00421086, 0x015ab800,
        0x00949800, 0x0064a4c0, 0x0013a4c0, 0x008724c0, 0x00108da0, 0x0064104c,
        0x00c23880, 0x0164a520, 0x00452800, 0x00aad400, 0x00a22800, 0x00111140,
        0x00e221c0, 0x00c2088c, 0x00421084, 0x00622086, 0x000022a2, 
    ]

    # 全画面一気に描画する
    # 例:
    #   raster do |x, y|
    #     if x + y % 2 == 0
    #       gray
    #     else
    #       white
    #     end
    #   end
    def raster
      height.times do |y|
        width.times do |x|
          if color = yield(x, y)
            self[x, y] = color
          end
        end
      end
    end
  end
end
