# GCC開発環境Dockerイメージ作成リポジトリ
## 概要
GCC開発環境作成Dockerイメージである。
DockerHubのリポジトリに置かれており名前はkagalpandh/kacpp-gccdev。
GCC開発環境はインストールするとサイズが大きくなるため
APTパッケージリストにインストールするパッケージを記述しておきそこから
インスト・削除するスクリプトを用意した。
さらにソースコードからインストールするものに対してporgもインストールしてある。
このイメージにはGCC開発環境はインストールされていない。

## 使い方
```shell
docker image pull kagalpandh/kacpp-gccdev
```
Dockerイメージとして取得できる。

## このdockerイメージの構成
GCC開発環境はサイズが大きくなるのでスクリプトでAPTパッケージリストファイルに
パッケージ名を記述しておきそこからインストール・削除するスクリプトを作成した。
このスクリプトでまとめてGCC開発環境をインストールする。
スクリプトは/usr/local/sh/system/apt-install.shにありAPTパッケージリストファイルは
/usr/local/sh/apt-installにある。
GCC開発環境用APTパッケージリストファイルはgccdev.txtである。
このスクリプトの使い方はまずインストール・削除したいパッケージを記述したファイル
APTパッケージリストファイルを用意し以下のようにコマンドラインに指定する。
```shell
/usr/local/sh/system/apt-install.sh install|uninstall [files...]
```
installとuninstallはコマンドでfilesは引数でAPTパッケージリストファイルを複数指定する。
引数を指定しない場合は/usr/local/sh/apt-installのAPTパッケージリストファイル全てが対象。
またこのコマンドにパスを通すため/etc/rc.d/rcprofileをおコピーした。

## Dockerコンテナとしての使い方
DokerfileにFromでベースにこのイメージを指定した後、
```shell
FROM    kagalpandh/kacpp-gccdev
....
RUN     apt update \
        && /usr/local/sh/system/apt-install.sh install gccdev.txt \
        ...コンパイル作業
        # 終了処理
        && /usr/local/sh/system/apt-install.sh uninstall gccdev.txt \
        && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*
```
を実行する。終了処理はまずapt autoremove -y
をしないと使用しないパッケージも削除しないので指定すること。
そしてDockerはRUNなどのコマンドでレイヤーを形成する。
RUNで一度開発環境を入れもう一度RUNで削除処理を行うとサイズが小さくならないので削除と
GCC開発環境のインストールとコンパイルは同じRUNで行う。

## その他
Dockerイメージ名: kagalpandh/kacpp-gccdev
DockerHubのURL: [kacpp-gccdev](https://hub.docker.com/repository/docker/kagalpandh/kacpp-gccdev)
github: https://github.com/karakawa88/kacpp-gccdev

