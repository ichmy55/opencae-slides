## Branch
本リポジトリでは、以下３段階のブランチを使用しています
| 所在 | 名称 | 概要 |
| ---- | ---- | ---- |
| ローカル |origin| ご自身お手元のPC上のブランチ|
| リモート |development| 開発用ブランチでいつでもPUSH可能|
|^         |main| 上記ブランチで問題ないことを確認の上PR。直接PUSH禁止|

## CI/CD
本リポジトリでは,CI/CD用のGitHub actions設定ファイルを大きく分けて4種類用意し、設定しています.  
(1) タイミング設定ファイル  
本リポジトリでは,各起動タイミングごとの実施内容を記述するファイルを設けています
| ファイル名       | 起動タイミング                                |
| ---------------- | --------------------------------------------- | 
| develop-push.yml |developmentブランチへのPUSHが行われたとき      |
| main-pr.yml      |mainブランチへのPRが発行されたとき             |
| main-push.yml    |PRが承認されmainブランチへのmergeが行われたとき|

ここには,具体的な実施内容は書かず,下記(2)各ファイルの呼び出しのみ行います.  

(2) 実施内容設定ファイル  
具体的な実施内容は,以下ファイルに記載しています.  
|                        |                                                   | 起動元           |         |           |
| :--------------------- | :------------------------------------------------ | :--------------: | :-----: | :-------: |
| ファイル名             | 内容                                              | develop-<br>push | main-pr | main-push | 
| build-pdf.yml          | PDFファイルをbuildします                          |  〇              |         | 〇        |
| textlint-reviewdog.yml | textlint実施し、問題があればPRにコメントを加えます|                  |  〇     |           |
| package-textcomp.yml   | PDFファイルのbuild用のDocker imageを生成します    |                  |         | (※注1)    |
| release-drafter.yml    | リリースを作成し、バージョンを更新します          |                  |         | 〇        |
| release-update.yml     | 上記リリースにPDFファイルを追記します             |                  |         | 〇        |

(※注1)：PDFファイルのbuild用のDockerfileが変更されたときのみ走ります.  

(3) 設定ファイル  
上記実施に必要な設定ファイルは,以下に記載しています.  
| ファイル名           | 内容                          | 
| :------------------- | :---------------------------- |
| dependabot.yml       | dependabot用設定ファイル      |
| release-drafter.yml  | release-drafter用設定ファイル |

(4) スクリプトファイル  
上記実施に必要なスクリプトファイルは,以下に記載しています.  
| ファイル名           | 内容                      | 
| :------------------- | :------------------------ |
| convert.py           | release-drafter用ファイル |
| run.sh               | release-drafter用ファイル |

## Versioning strategies
本リポジトリでは、セマンティック バージョニングを採用し、以下バージョン戦略を使用しています
| 名称         | 上げるタイミング                                                                       |
| ------------ | -------------------------------------------------------------------------------------- |
| パッチ番号   |mainへのPRが通って、マージに至るたびに自動でUp                                          |
| マイナー番号 |PDF作成対象となる勉強会の変更、追加、削除(PRに"minor"ラベルをつけマージされると自動でUp)|
| メジャー番号 |次回勉強会の最終稿で0→1に上げる予定. 1→2は、未定                                        |
