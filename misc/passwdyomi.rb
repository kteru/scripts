#!/usr/bin/ruby -Ku
# -*- coding: utf-8 -*-
#
# 20120705
# password yomi
#


# 読み
hash_yomi = Hash.new

hash_yomi[48]  = 'ゼロ'
hash_yomi[49]  = 'イチ'
hash_yomi[50]  = 'ニ'
hash_yomi[51]  = 'サン'
hash_yomi[52]  = 'ヨン'
hash_yomi[53]  = 'ゴ'
hash_yomi[54]  = 'ロク'
hash_yomi[55]  = 'ナナ'
hash_yomi[56]  = 'ハチ'
hash_yomi[57]  = 'ク'

hash_yomi[97]  = 'エイ'
hash_yomi[98]  = 'ビー'
hash_yomi[99]  = 'シー'
hash_yomi[100] = 'ディー'
hash_yomi[101] = 'イー'
hash_yomi[102] = 'エフ'
hash_yomi[103] = 'ジー'
hash_yomi[104] = 'エイチ'
hash_yomi[105] = 'アイ'
hash_yomi[106] = 'ジェイ'
hash_yomi[107] = 'ケイ'
hash_yomi[108] = 'エル'
hash_yomi[109] = 'エム'
hash_yomi[110] = 'エヌ'
hash_yomi[111] = 'オー'
hash_yomi[112] = 'ピー'
hash_yomi[113] = 'キュー'
hash_yomi[114] = 'アール'
hash_yomi[115] = 'エス'
hash_yomi[116] = 'ティー'
hash_yomi[117] = 'ユー'
hash_yomi[118] = 'ヴィー'
hash_yomi[119] = 'ダブリュー'
hash_yomi[120] = 'エックス'
hash_yomi[121] = 'ワイ'
hash_yomi[122] = 'ゼッド'

hash_yomi[33]  = 'エクスクラメーション'
hash_yomi[34]  = 'ダブルクォーテーション'
hash_yomi[35]  = 'シャープ'
hash_yomi[36]  = 'ダラー'
hash_yomi[37]  = 'パーセント'
hash_yomi[38]  = 'アンパサンド'
hash_yomi[39]  = 'シングルクォート'
hash_yomi[40]  = 'カッコ'
hash_yomi[41]  = 'カッコ閉じ'
hash_yomi[42]  = 'アスタリスク'
hash_yomi[43]  = 'プラス'
hash_yomi[44]  = 'カンマ'
hash_yomi[45]  = 'ハイフン'
hash_yomi[46]  = 'ドット'
hash_yomi[47]  = 'スラッシュ'

hash_yomi[58]  = 'コロン'
hash_yomi[59]  = 'セミコロン'
hash_yomi[60]  = '小ナリ'
hash_yomi[61]  = 'イコール'
hash_yomi[62]  = '大ナリ'
hash_yomi[63]  = 'クエスチョン'
hash_yomi[64]  = 'アット'

hash_yomi[91]  = '大カッコ'
hash_yomi[92]  = 'バックスラッシュ'
hash_yomi[93]  = '大カッコ閉じ'
hash_yomi[94]  = 'キャレット'
hash_yomi[95]  = 'アンダーバー'
hash_yomi[96]  = 'バッククォート'

hash_yomi[123] = '中カッコ'
hash_yomi[124] = '縦棒'
hash_yomi[125] = '中カッコ閉じ'
hash_yomi[126] = 'チルダ'


# 引数 or キー入力
passwords = ''
if ARGV[0] != nil then
  passwords = ARGV.join("\n") + "\n"
else
  print "input password:"
  passwords = gets
end


# パスワード毎に
passwords.each_line do |password|
  # 改行除去
  password.chomp!
  next if password == ''

  yomi = []

  # 読み取得
  password.downcase.each_byte {|c|
    yomi.push(hash_yomi[c])
  }

  # 読み出力
  print password + "\n"
  print "(" + yomi.join(',') + ")\n"
end

