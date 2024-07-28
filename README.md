# opencae-slides

## Overview
OpenCAE学会の各後援勉強会などにて報告する際のスライドのTexソースを公開するためのリポジトリです  
Texをコンパイルするには環境構築が必要ですが、自分の環境をなるだけ汚したくない方にも、  
お使いいただくための環境例ともなっています。  
docker上にソースを転送したうえでコンパイルすることで、母艦の環境を汚しません。  
(母艦環境にパッケージを入れる必要がありますが)dockerを使わずにローカルでコンパイルもできます

## Requirement
現時点では、本ソースを動かすコンピュータ環境はUbuntuを想定しています。  
（将来的には、他OSでも動作可能にする予定）
dockerとdocker-composeのインストールをお願いします。(ローカルでコンパイル時は不要)  
また、本ソースコードをダウンロードするためにgitもインストールをお願いします。

## Installation
適当な作業ディレクトリを作成し、本ソースをcloneしてください

```
$ git clone https://github.com/ichmy55/opencae-slides.git
```

## Directory tree
上記展開すると以下のようなディレクトリ構成になります
<pre>
.
├── Dockerfile
├── Makefile
├── README.md
├── docker-compose.yml
├── .github
│   └── workflow .............GithubでのCI/CO設定ファイルを入れます
├── .textlintrc.json..........自動校正textlint用ルールファイル
├── src ......................このディレクトリにTexのソースファイルを配置します
│   └── opencae-kantou-s-025..ソースは勉強会毎のディレクトリにそれぞれ入れます
│   └── opencae-kantou-s-027..ソースは勉強会毎のディレクトリにそれぞれ入れます
│         ├── geometry........使用する形状ファイルを入れます
│         └── images..........勉強会毎のディレクトリにTexから読み込む画像ファイルを入れます
├── dist......................このディレクトリに結果pdfが生成されます。Make時に生成されます
└── work......................ワーク用です。Make時に生成されます
</pre>

## Settings of  Makefile
Makefile中の変数「DEST_PDF」の値を、PDF作成したい勉強会のディレクトリ名に変えて下さい
```
#
# 作成するスライド名
#
DEST_PDF := opencae-kantou-s-027
```

## Usage
make一発で、docker環境の生成、docker環境へのソース転送、結果pdf生成し、同ファイルをdocker環境から
引き出すところまで自動でやります．
結果ファイルが「dist」ディレクトリに格納されますので、取り出してください。
ローカルでコンパイルする場合は、$ make localbuildでコンパイルします。
この場合は、ローカルに必要なパッケージを入れる必要があります。
Dokerfileを参考にして、設定してください。

## Textlint
本リポジトリでは、自動校正に以下のルールを用いています
| ルール名 | ルール概要 | ルールの配布元 |
| ---- | ---- | ---- |
| textlint-rule-ja-hiragana-fukushi | 漢字よりもひらがなで表記したほうが読みやすい副詞を指摘する| [GitHub](https://github.com/lostandfound/textlint-rule-ja-hiragana-fukushi)|
| textlint-rule-no-doubled-joshi | 1つの文中に同じ助詞が連続して出てくるのをチェックする| [GitHub](github.com/textlint-ja/textlint-rule-no-doubled-joshi)|
| preset-ja-spacing |日本語周りにおけるスペースの有無| [GitHub](github.com/textlint-ja/textlint-rule-preset-ja-spacing)|

## Distribution
生成したスライドPDFは、[Docswell](https://www.docswell.com/user/ichmy55) にて公開しております

## Author

[ichmy55](https://github.com/ichmy55)

## Licence
"opencae-slides" の各ソースコードは [MIT license](https://ja.wikipedia.org/wiki/MIT_License) で配布します。  
また、このコードで生成されたファイルは、[クリエイティブ・コモンズ・ライセンス](https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AA%E3%82%A8%E3%82%A4%E3%83%86%E3%82%A3%E3%83%96%E3%83%BB%E3%82%B3%E3%83%A2%E3%83%B3%E3%82%BA%E3%83%BB%E3%83%A9%E3%82%A4%E3%82%BB%E3%83%B3%E3%82%B9)表示4.0国際で配布します

