# GCCコンパイラ環境を持つdebianイメージ
# 日本語化も設定済み
# ソースコードのパッケージも管理するためporgも入れる
FROM        kagalpandh/kacpp-ja
SHELL       [ "/bin/bash", "-c" ]
WORKDIR     /root
ENV         DEBIAN_FORONTEND=noninteractive
# porg関連環境変数
ENV         PORG_VERSION=0.10
ENV         PORG_SRC_BASE_URL="https://sourceforge.net/projects/porg/files/"
ENV         PORG_SRC_FILE=porg-${PORG_VERSION}.tar.gz
ENV         PORG_SRC_URL="https://sourceforge.net/projects/porg/files/${PORG_SRC_FILE}/download"
# APTパッケージインストールスクリプト環境
RUN         mkdir /usr/local/sh
COPY        sh/    /usr/local/sh
RUN         chmod 3770 /usr/local/sh && chmod 3770 /usr/local/sh/system \
            && chmod 3770 /usr/local/sh/apt-install && chmod 775 /usr/local/sh/system/apt-install.sh
# シェルスクリプト環境にパスを通すためprofileをコピー
# /usr/local/sh/system
COPY        profile     /etc/profile
COPY        rcprofile  /etc/rc.d
COPY        .wgetrc   /root
RUN         cp .wgetrc /etc/skel
# 開発環境インストール
# porgインストール
# configureで--disable-gropしているのはGUIソフトをインストールしないため
RUN         apt update \
                && apt install -y software-properties-common git wget gpg \
                && /usr/local/sh/system/apt-install.sh install gccdev.txt \
            && wget ${PORG_SRC_URL} && tar -zxvf ${PORG_SRC_FILE} && cd porg-${PORG_VERSION} \
                && ./configure --prefix=/usr/local --disable-grop   && make && make install \
            && /usr/local/sh/system/apt-install.sh uninstall gccdev.txt \
            && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/* && cd ../ && rm -rf porg-* 
ENV         SH=/usr/local/sh
ENV         PATH=${PATH}:${SH}/system
#終了処理
#RUN         apt clean && rm -rf /var/lib/apt/lists/* && rm -rf porg-* 
