#
# Texをコンパイルする環境を作成する Makefile
#
#
# Docker コマンドマクロ
#
COMPOSE := docker compose
#
# Latex エンジン
#
LATEXENG := lualatex
#
# 作成するスライド名
#
DEST_PDF := opencae-kantou-s-027
#
# ソースファイル一覧
#
SRCDIR := src/$(DEST_PDF)
SRCS := $(wildcard  $(SRCDIR)/*.tex) $(wildcard src/images/*)

#
# Latex コンパイル方法の定義マクロ
#
define F2
$(2): $(1)
	@$(LATEXENG)$(1)
	mv main.pdf $(2)
	rm -f main.*
endef

#
# ターゲット一覧
#
.PHONY: first up ps stop down  clean build bash localbuild localclean localup localtest
#
first: localbuild
#
# Docker compose 制御ターゲット
#
# コンテナを初期設定します
up:
	@$(COMPOSE) up -d
	make clean
#
# コンテナを確認します
ps:
	@$(COMPOSE) ps
#
# コンテナの停止
stop:
	@$(COMPOSE) stop
#
# コンテナを停止し，upで作成したコンテナ，ネットワーク，ボリューム，イメージを削除
# 
down:
	@$(COMPOSE) down --rmi all
#
# コンテナ上のデータ整理（いったん全部消して、ローカルから持上）
# 
clean:
	@$(COMPOSE) exec -it opencae-slides rm -rf *
	@$(COMPOSE) cp Makefile opencae-slides:/home/ubuntu/
	@$(COMPOSE) cp src opencae-slides:/home/ubuntu/src
#
# コンテナ上のビルド
# 
build:
	make clean
	@$(COMPOSE) exec -it opencae-slides make localbuild
	@$(COMPOSE) cp opencae-slides:/home/ubuntu/dist .
#
# コンテナへのログイン
# 
bash:
	@$(COMPOSE) exec -it opencae-slides bash
#
# ローカルでのビルド関連ターゲット
#
localbuild: pdf-files

pdf-files: $(addprefix dist/,$(addsuffix .pdf,$(DEST_PDF)))

$(addprefix dist/,$(addsuffix .pdf,$(DEST_PDF))) : $(SRCS)
	make localclean
	make localup
	@$(LATEXENG) work/000-main.tex
	@$(LATEXENG) work/000-main.tex
	mv 000-main.pdf $@
	rm -f 000-main.*

localclean:
	rm -rf  000-main.* work dist; mkdir -p dist work

localup:
	cp -rL $(SRCDIR)/* work/
