# GCCコンパイラ環境を持つdebianイメージ
# GCCバージョンは10。
# 日本語化も設定済み
# ソースコードのパッケージも管理するためporgも入れる
FROM        kagalpandh/kacpp-ja:debian-buster-slim
SHELL       [ "/bin/bash", "-c" ]
WORKDIR     /root
ENV         DEBIAN_FORONTEND=noninteractive
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
RUN         chmod 3770 /usr/local/sh && chmod 3770 /usr/local/sh/system && \
                chmod 3770 /usr/local/sh/apt-install && \
                chmod 775 /usr/local/sh/system/apt-install.sh && \
            apt update && \
                apt install -y software-properties-common git wget gpg && \
                /usr/local/sh/system/apt-install.sh install gccdev.txt  && \
#            && /usr/local/sh/system/apt-install.sh uninstall gccdev.txt \
            apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*
#             cd ../ && rm -rf porg-* 
ENV         SH=/usr/local/sh
ENV         PATH=${PATH}:${SH}/system
#終了処理
#RUN         apt clean && rm -rf /var/lib/apt/lists/* && rm -rf porg-* 
