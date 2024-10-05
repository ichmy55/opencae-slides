#
# Texをコンパイルする環境を作成する Makefile
#
#
# Docker コマンドマクロ
#
DOCKER := docker
DOCKER_IMAGE  := ghcr.io/ichmy55/opencae-slides/texcomp:main
DOCKER_NAME   := opencae-slides
#
# Latex エンジン
#
LATEXENG := lualatex
#
# 作成するスライド名
#
DEST_PDF := opencae-kantou-s-028
#
# ソースファイル一覧
#
SRCDIR := src/$(DEST_PDF)
SRCS   := $(wildcard  $(SRCDIR)/*.tex)
SRCS2  := $(SRCS) $(wildcard src/images/*)
DOCS   := $(wildcard  docs/*.md)

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
.PHONY: first up ps stop down  clean build bash localbuild localclean localup localtest local-lint
#
first: localbuild
#
# Docker compose 制御ターゲット
#
# コンテナを初期設定します
up:
	make down
	$(DOCKER) build . -t $(DOCKER_NAME)
	$(DOCKER) run -d -v $(PWD)/src:/home/ubuntu/src -v $(PWD)/rules:/home/ubuntu/rules --name $(DOCKER_NAME) $(DOCKER_NAME)
	make build
	make clean
#
# コンテナを確認します
ps:
	@$(DOCKER) ps -a
#
# コンテナの停止
stop:
	@$(DOCKER) stop $(DOCKER_NAME)
#
# コンテナを停止し，upで作成したコンテナ，ネットワーク，ボリューム，イメージを削除
# 
down:
	$(DOCKER) rm -f  $(DOCKER_NAME)
#
# コンテナ上のデータ整理（いったん全部消して、ローカルから持上）
# 
clean:
	@$(DOCKER) cp Makefile  $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) cp README.md $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) cp .textlintrc.json $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) cp VERSION.txt $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) exec -it $(DOCKER_NAME) make localclean
#
# コンテナ上のビルド
# 
build:
	make clean
	@$(DOCKER) exec -it $(DOCKER_NAME) make localbuild
	@$(DOCKER) cp $(DOCKER_NAME):/home/ubuntu/dist .
#
# コンテナ上のLint
# 
lint:
	make clean
	@$(DOCKER) exec -it $(DOCKER_NAME) make local-lint
#
# コンテナへのログイン
# 
bash:
	@$(DOCKER) exec -it $(DOCKER_NAME) /bin/bash
#
# ローカルでのビルド関連ターゲット
#
localbuild: pdf-files

pdf-files: $(addprefix dist/,$(addsuffix .pdf,$(DEST_PDF)))

$(addprefix dist/,$(addsuffix .pdf,$(DEST_PDF))) : $(SRCS2)
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
	cp VERSION.txt  work/

local-lint:
	npx textlint -f pretty-error README.md $(SRCS) $(DOCS)
