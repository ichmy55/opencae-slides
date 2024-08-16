# opencae-slides

## Overview
OpenCAE学会の各後援勉強会などにて報告する際のスライドのTexソースを公開するためのリポジトリです.
Texをコンパイルするには環境構築が必要ですが,自分の環境をなるだけ汚したくない方にも,  
活用いただくための環境例とも,なっています.
どのくらい自分の環境を汚せるかによって,以下の３レベルの使い方が可能です
1. 自身の環境を一切汚したくない → TexコンパイルをGitHub上で実施
2. Docker環境を用意する程度なら許容 → Texコンパイルをdockerコンテナ内で実施
3. 多少のパッケージ導入なら許容 → Texコンパイルをローカル環境で実施

## Requirement
自分の母艦の環境で必要となる設定は,上記のいずれの使い方をするかで異なり,
上記１のGitHub上でソース編集→コンパイルだと,自身の環境は汚さず,ブラウザのみ要(OS,CPU種類は問わない).
上記２の場合はdocker環境と,好みのエディタのインストールをお願いします(OS,CPU種類は問わない).
上記３の場合は,本ソースを動かすコンピュータ環境はUbuntuを想定しています.
上記３の場合は,Dockerfile内に示している各種パッケージが必要となります.
Windowsなど,ほかのOSの場合は仮想環境でUbuntu環境を用意してください.

## Installation
適当な作業ディレクトリを作成し,本ソースをcloneしてください.

```
$ git clone https://github.com/ichmy55/opencae-slides.git
```

## Directory tree
上記展開すると以下のようなディレクトリ構成になります.
<pre>
.
├── README.md
├── Makefile
├── Dockerfile................Texコンパイル用のDockerイメージを作る.
├── Dockerfile2...............Textlintで自動校正用のDockerイメージを作る.
├── .github/workflow .........GitHubでのCI/CO設定ファイル.
├── .textlintrc.json..........自動校正textlint用ルールファイル.
├── rules ....................自動校正prh用辞書ファイル.
├── src ......................このディレクトリにTexのソースファイルを配置します.
│   └── opencae-kantou-s-025..ソースは勉強会毎のディレクトリにそれぞれ入れます.
│   └── opencae-kantou-s-027..ソースは勉強会毎のディレクトリにそれぞれ入れます.
│         ├── geometry........使用する形状ファイルを入れます.
│         └── images..........勉強会毎のディレクトリにTexから読み込む画像ファイルを入れます.
├── dist......................このディレクトリに結果pdfが生成されます.Make時に生成されます.
└── work......................ワーク用です.Make時に生成されます.
</pre>

## Settings of  Makefile
Makefile中の変数「DEST_PDF」の値を,PDF作成したい勉強会のディレクトリ名に変えてください.
```
#
# 作成するスライド名
#
DEST_PDF := opencae-kantou-s-027
```

## Usage
make一発で,docker環境の生成,docker環境へのソース転送,結果pdf生成し,同ファイルをdocker環境から
引き出すところまで自動でやります．
結果ファイルが「dist」ディレクトリに格納されますので,取り出してください.
ローカルでコンパイルする場合は,$ make localbuildでコンパイルします.
この場合は,ローカルに必要なパッケージを入れる必要があります.如何に
Dokerfileを参考にして,設定してください.

## Textlint
<!-- textlint-disable prh -->
本リポジトリでは,自動校正に以下のルールを用いています.
<!-- textlint-enable prh -->
| ルール名 | ルール概要 | ルールの配布元 |
| ---- | ---- | ---- |
| preset-ja-spacing |日本語周りにおけるスペースの有無| [GitHub](https://github.com/textlint-ja/textlint-rule-preset-ja-spacing)|
| textlint-rule-prh |表記ゆれの修正のための辞書ベースのツール| [GitHub](https://github.com/textlint-rule/textlint-rule-prh)|

## Distribution
生成したスライドPDFは,[Docswell](https://www.docswell.com/user/ichmy55) にて公開しています.

## Author

[ichmy55](https://github.com/ichmy55)

## Licence
"opencae-slides" の各ソースコードは [MIT license](https://ja.wikipedia.org/wiki/MIT_License) で配布します.  
また,このコードで生成されたファイルは,[クリエイティブ・コモンズ・ライセンス](https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AA%E3%82%A8%E3%82%A4%E3%83%86%E3%82%A3%E3%83%96%E3%83%BB%E3%82%B3%E3%83%A2%E3%83%B3%E3%82%BA%E3%83%BB%E3%83%A9%E3%82%A4%E3%82%BB%E3%83%B3%E3%82%B9)表示4.0国際で配布します.
