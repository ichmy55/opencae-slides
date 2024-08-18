#
# Texをコンパイルする環境を作成する Makefile
#
#
# Docker コマンドマクロ
#
DOCKER := docker
DOCKER_IMAGE  := ghcr.io/ichmy55/opencae-slides/texcomp:main
DOCKER_IMAGE2 := ghcr.io/ichmy55/opencae-slides/textlint:main
DOCKER_NAME   := opencae-slides
DOCKER_NAME2  := opencae-textlint
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
SRCS   := $(wildcard  $(SRCDIR)/*.tex)
SRCS2  := $(SRCS) $(wildcard src/images/*)

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
	$(DOCKER) pull $(DOCKER_IMAGE)
	$(DOCKER) pull $(DOCKER_IMAGE2)
	$(DOCKER) rm -f  $(DOCKER_NAME)
	$(DOCKER) rm -f  $(DOCKER_NAME2)
	$(DOCKER) run -d --name $(DOCKER_NAME)  $(DOCKER_IMAGE) sleep infinity
	$(DOCKER) run -d --name $(DOCKER_NAME2) $(DOCKER_IMAGE2) sleep infinity
	make clean
#
# コンテナを確認します
ps:
	@$(DOCKER) ps -a
#
# コンテナの停止
stop:
	@$(DOCKER) stop $(DOCKER_NAME)
	@$(DOCKER) stop $(DOCKER_NAME2)
#
# コンテナを停止し，upで作成したコンテナ，ネットワーク，ボリューム，イメージを削除
# 
down:
	$(DOCKER) rm -f  $(DOCKER_NAME)
	$(DOCKER) rm -f  $(DOCKER_NAME2)
#
# コンテナ上のデータ整理（いったん全部消して、ローカルから持上）
# 
clean:
	@$(DOCKER) exec -it opencae-slides rm -rf *
	@$(DOCKER) cp Makefile opencae-slides:/home/ubuntu/
	@$(DOCKER) cp src opencae-slides:/home/ubuntu/src
	@$(DOCKER) exec -it opencae-textlint rm -rf *
	@$(DOCKER) cp Makefile opencae-textlint:/home/ubuntu/
	@$(DOCKER) cp README.md opencae-textlint:/home/ubuntu/
	@$(DOCKER) cp .textlintrc.json opencae-textlint:/home/ubuntu/
	@$(DOCKER) cp src opencae-textlint:/home/ubuntu/src
	@$(DOCKER) cp rules opencae-textlint:/home/ubuntu/rules
#
# コンテナ上のビルド
# 
build:
	make clean
	@$(DOCKER) exec -it opencae-slides make localbuild
	@$(DOCKER) cp opencae-slides:/home/ubuntu/dist .
#
# コンテナ上のLint
# 
lint:
	make clean
	@$(DOCKER) exec -it opencae-textlint make local-lint
#
# コンテナへのログイン
# 
bash:
	@$(DOCKER) exec -it opencae-slides bash
bash2:
	@$(DOCKER) exec -it opencae-textlint bash
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

local-lint:
	npx textlint -f pretty-error README.md $(SRCS)
