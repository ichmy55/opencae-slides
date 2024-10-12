#
# Texをコンパイルする環境を作成する Makefile
#
#
# ターゲット一覧
#
.PHONY: help up ps stop down  clean build bash localbuild localclean localup localtest local-lint
.DEFAULT_GOAL := help
#
# Docker コマンドマクロ
#
DOCKER := docker
DOCKER_IMAGE  := ghcr.io/ichmy55/opencae-slides/texcomp:main
DOCKER_NAME   := opencae-slides
#
# Latex エンジン
#
LATEXENG := latexmk -lualatex
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
help: ## ヘルプを表示する
	@echo "Example operations by makefile."
	@echo ""
	@echo "Usage: make SUB_COMMAND argument_name=argument_value"
	@echo ""
	@echo "Command list:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
#
# Docker compose 制御ターゲット
#
up: ## コンテナを初期化します
	make down
	rm -rf ltcache
	mkdir ltcache
	@$(DOCKER) build . -t $(DOCKER_NAME)
	@$(DOCKER) run -d -v $(PWD)/src:/home/ubuntu/src -v $(PWD)/rules:/home/ubuntu/rules  -v$(PWD)/ltcache:/home/ubuntu/.texlive2023 --name $(DOCKER_NAME) $(DOCKER_NAME)
	make remoteclean
	@$(DOCKER) exec -it $(DOCKER_NAME) luaotfload-tool --update
#
stop: ## コンテナを停止します
	@$(DOCKER) stop $(DOCKER_NAME)
#
down: ## コンテナを停止し，upで作成したコンテナ，ネットワーク，ボリューム，イメージを削除
	@$(DOCKER) rm -f  $(DOCKER_NAME)
#
ps: ## コンテナを確認します
	@$(DOCKER) ps -a
#
bash: ## コンテナへログインします
	@$(DOCKER) exec -it $(DOCKER_NAME) /bin/bash
#
# 現在Docker内か外か？を自動判定し分岐します
# Docker内環境からはローカルで実行します
# Docker外環境からはDocker環境を立ち上げ、そちらで実行するようにします
# どちらで実行するか強制したい場合は、ここより下にある、remote***やlocal***などの
# 接頭語がついたターゲットを使用してください
#
build: ## latexからpdfにコンパイルします(環境は自動判別)
ifndef CONTAINER_ENV
	make remotebuild
else
	make localbuild
endif
#
lint: ## latexをLintにかけます(環境は自動判別)
ifndef CONTAINER_ENV
	make remotelint
else
	make local-lint
endif
clean: ## データ整理(環境は自動判別)
ifndef CONTAINER_ENV
	make remoteclean
else
	make localclean
endif
#
# コンテナ環境下でのビルド関連ターゲット
#
remotebuild: ## コンテナ環境にてlatexからpdfにコンパイルします
	make remoteclean
	@$(DOCKER) exec -it $(DOCKER_NAME) make localbuild
	@$(DOCKER) cp $(DOCKER_NAME):/home/ubuntu/dist .
#
# 
remotelint: ## コンテナ環境にてlatexをLintにかけます
	make remoteclean
	@$(DOCKER) exec -it $(DOCKER_NAME) make local-lint
#
remoteclean: ## コンテナ上のデータ整理（いったん全部消して、ローカルから持上）
	make localclean
	@$(DOCKER) cp ./Makefile  $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) cp README.md $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) cp .textlintrc.json $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) cp VERSION.txt $(DOCKER_NAME):/home/ubuntu/
	@$(DOCKER) exec -it $(DOCKER_NAME) make localclean
#
# ローカルでのビルド関連ターゲット
#
localbuild: pdf-files ## ローカル環境下でlatex→pdfにコンパイルします

pdf-files: $(addprefix dist/,$(addsuffix .pdf,$(DEST_PDF)))

$(addprefix dist/,$(addsuffix .pdf,$(DEST_PDF))) : $(SRCS2)
	make localclean
	make localup
	@$(LATEXENG) work/000-main.tex
	mv 000-main.pdf $@
	rm -f 000-main.*

local-lint: ## ローカル環境下でlatexをlintにかけます
	npx textlint -f pretty-error README.md $(SRCS) $(DOCS)

localclean: ## ローカル環境の不要ファイルを消します
	rm -rf  000-main.* work dist; mkdir -p dist work

localup:
	cp -rL $(SRCDIR)/* work/
	cp VERSION.txt  work/

distclean: ## ローカル環境の不要ファイルを消し、latexのフォントキャッシュも消します
	make localclean
	rm -rf  ltcache

name: ## 生成するスライド名を出力します
	@echo "DEST_PDF=$(DEST_PDF).pdf"
