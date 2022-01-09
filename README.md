# Name
Photo Copy
- デジタルカメラの写真・動画ファイルをコンピュータにコピーするシェルスクリプト

# Features
- デジタルカメラの写真・動画ファイルをコンピュータにコピーする
- JPEGファイル、RAWファイル、動画ファイルをそれぞれ指定のフォルダに振り分ける
- ファイル種類別フォルダの中に日付フォルダを作成する
- ファイル名は、年月日時分秒＋ランダムな3桁の数字＋拡張子。
- 例 `/Photo/2022/2022-01-08/2022-01-08_172926_949.JPG`

# Requirement
- Bashが動作するコマンドライン環境
- 作者は Mac mini (Intel版)で動作確認

# Installation
- photo_copy.sh, photo_copy.conf を　`~/bin` ディレクトリにコピーする
- photo_copy.sh に実行パーミッションを付与する
```
$ chmod +x ~/bin/photo_copy.sh
```
- photo_copy.conf を自分の環境に合うように編集する
- `~/bin` にパスが通っていない場合はパスを通す
.bashrcを編集
```
$ vim ~/.bashrc
```
次の行がなければ追加
```
export PATH=$HOME/bin:$PATH
```
変更内容を読み込む
```
$ source ~/.bashrc
```

# Usage
- 次のコマンドを実行する
```
photo_copy.sh
```
- コピー元を設定ファイルではないものに変更したい場合は引数に指定する
```
photo_copy.sh /Volumes/hoge/fuga
```
- 実行例
```
$ photo_copy.sh 
Copying /Volumes/Untitled/DCIM/100OLYMP/P1080001.JPG to /Volumes/USB-HD-1TB/Media/Photo/2022/2022-01-08/2022-01-08_172926_949.JPG
Copying /Volumes/Untitled/DCIM/100OLYMP/P1080001.ORF to /Volumes/USB-HD-1TB/Media/PhotoRaw/2022/2022-01-08/2022-01-08_172926_317.ORF
Image file copying finished.
```

# Author
- 作成者:　山田順二 / YAMADA Junji
- 所属: フリーランスITエンジニア
- E-mail: junji[at]junyx.net (Replace [at] with @)

# License
- Photo Copy is under [MIT license](https://en.wikipedia.org/wiki/MIT_License).
