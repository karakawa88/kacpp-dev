# 開発環境を持つdebianイメージ
# gcc rust の環境を持つ
# 日本語化も設定済み
# ソースコードのパッケージも管理するためporgも入れる
FROM        kagalpandh/kacpp-ja
SHELL       [ "/bin/bash", "-c" ]
WORKDIR     /root
ENV         DEBIAN_FORONTEND=noninteractive
# APTパッケージインストールスクリプト環境
RUN         mkdir /usr/local/sh
COPY        sh/    /usr/local/sh
# シェルスクリプト環境にパスを通すためprofileをコピー
# /usr/local/sh/system
COPY        profile     /etc/profile
COPY        rcprofile  /etc/rc.d
COPY        .wgetrc   /root
RUN         cp .wgetrc /etc/skel
# 開発環境インストール
RUN         cd /root && source /etc/rc.d/rcprofile && \
            echo "/usr/local/lib" >> /etc/ld.so.conf && \
            chmod 3770 /usr/local/sh && chmod 3770 /usr/local/sh/system && \
                chmod 3770 /usr/local/sh/apt-install && \
<<<<<<< HEAD
                chmod 775 /usr/local/sh/system/apt-install.sh
#GCCをインストール
RUN         apt update && \
                apt install -y software-properties-common curl git wget gpg && \
                /usr/local/sh/system/apt-install.sh install gccdev.txt && \
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o ./rustup.rs && \ 
            chmod 775 rustup.rs && ./rustup.rs -y && \
            source "$HOME/.cargo/env" && \
            cargo install sccache --locked && \
            git clone --branch stable https://github.com/rui314/mold.git && \
            cd mold && \
            ./install-build-deps.sh && \
            cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=c++ -B build && \
            cmake --build build -j$(nproc) && \
            cmake --build build --target install && \
||||||| b39a203
                chmod 775 /usr/local/sh/system/apt-install.sh && \
            apt update && \
                apt install -y software-properties-common git wget gpg && \
                /usr/local/sh/system/apt-install.sh install gccdev.txt  && \
=======
                chmod 775 /usr/local/sh/system/apt-install.sh
#GCCをインストール
RUN         apt update && \
                apt install -y software-properties-common curl git wget gpg && \
                /usr/local/sh/system/apt-install.sh install gccdev.txt
#Rustをインストール
RUN         curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o ./rustup.rs && \ 
            chmod 775 rustup.rs && ./rustup.rs -y && \
            source "$HOME/.cargo/env" && \
            cargo install sccache --locked
# コンパイルツールをインストール
RUN        git clone --branch stable https://github.com/rui314/mold.git && \
            cd mold && \
            ./install-build-deps.sh && \
            cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=c++ -B build && \
            cmake --build build -j$(nproc) && \
            cmake --build build --target install && \
>>>>>>> dev
#            && /usr/local/sh/system/apt-install.sh uninstall gccdev.txt \
<<<<<<< HEAD
            apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/* && \
            rm -rf /root/mold
COPY        config.toml /root/.cargo
||||||| b39a203
            apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*
#             cd ../ && rm -rf porg-* 
=======
            apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/* && \
            rm -rf /root/mold && \
            ldconfig
COPY        config.toml /root/.cargo
>>>>>>> dev
ENV         SH=/usr/local/sh
ENV         PATH=${PATH}:${SH}/system
#終了処理
#RUN         apt clean && rm -rf /var/lib/apt/lists/* && rm -rf porg-* 
