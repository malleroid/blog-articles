---
title: Docker+VSCodeでAtCoder用の開発環境を簡単に作る(Python編)
tags:
  - Python
  - AtCoder
  - Docker
  - 競技プログラミング
  - VSCode
private: false
updated_at: '2021-12-07T00:11:47+09:00'
id: ab83b5ffb8ddfd58a4d3
organization_url_name: null
slide: false
ignorePublish: false
---
## はじめに

この記事はQiita主催 [競技プログラミングを始めたばかりの人に伝えたいことアドベントカレンダー](https://qiita.com/advent-calendar/2021/pre-competitive) 5日目の記事です。

https://qiita.com/advent-calendar/2021/pre-competitive


👈 @torifukukaiouさんの前日の記事は[こちら](https://qiita.com/torifukukaiou/items/9a2235d2476857f9ff32)
👉 @amaguri0408さんの翌日の記事は[こちら](https://qiita.com/amaguri0408/items/61d65c3bea3a5815d704)

## まえがき

競技プログラミングを始めたばかりの方へ向けた便利なCLIツールと私の競プロ環境を紹介します!

AtCoderは大変優れたサイトでブラウザ上でコーディングもテストも行えますが、
linterの補完を受けたり一度に全部のテストケースを試したいと思うことがありますね?

そんな方にオススメです。
画像の感じでコマンド一発でテストや提出ができるようになります。
![screenshot_1638625713.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/eeaf8e27-9a6f-c406-5fe0-8b9a5e416798.png)
![screenshot_1638625747.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/1f68e007-f4ef-91c7-c401-873309f65e4f.png)



## 環境

OS: Windows10 (Macも同様に可)
エディタ: VSCode

## 準備

### WSL

Windowsユーザーのみ行います。 
自身のWindowsのversionを確認して下さい。

WSLはWindows上でLinuxOSを動作させることができる仮想化技術です。
とても便利かつ開発に向かなかったWindowsマシンの救世主となってくれる素敵なシステムなので全人類setupしてほしい🥳

Windows10 2004 以降の方は、Powershellで

```
$ wsl --install
```

を実行するだけでWSLをsetupできます。

上記未満のversionを使用している方は公式の[こちら](https://docs.microsoft.com/ja-jp/windows/wsl/install-manual)を参考にsetupしてください。


### Docker

[公式サイト](https://www.docker.com/products/docker-desktop)からダウンロードしてインストールします。

Windowsユーザーのみ以下の作業が必要です。
WindowsのDockerDesktopはWSL Integrationがサポートされているので、setupしたWSLと連携します。

DockerDesktopの設定画面から

![screenshot_1638621337.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/a63f662b-bd5e-2d77-06dc-32f5741673e8.png)
![screenshot_1638621368.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/6bbf8379-29b5-bf61-7ce5-fe87c14acd81.png)

こんな感じに設定します。

詳しい情報が必要な場合は公式の[こちら](https://docs.microsoft.com/ja-jp/windows/wsl/tutorials/wsl-containers)


### VSCode

[公式サイト](https://azure.microsoft.com/ja-jp/products/visual-studio-code)からダウンロードしてインストールします。

拡張機能として[remote development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)だけは必須なので、インストールします。

## AtCoder用コンテナのセットアップ

[リポジトリ作りました](https://github.com/malleroid/atcoder_docker_vscode)
競プロのCLIツールである[online-judge-tools](https://github.com/online-judge-tools/oj)と[atcoder-cli](https://github.com/Tatamo/atcoder-cli)を使えるPython実行環境があるコンテナになります。

### VSCodeでWSLへリモート接続

![screenshot_1638626344.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/2ddcb221-e65e-8023-4567-252916936660.png)

VSCodeを起動して、左下のリモートウィンドウボタンをクリックするとリモート接続のオプションが表示されるので`New WSL Window`を選択します。
これでWSLのLinuxOS上でVSCodeを起動できます。

ここでターミナルを起動して任意のディレクトリ配下でリポジトリをcloneします。

```
$ git clone https://github.com/malleroid/atcoder_docker_vscode.git
```

### AtCoder用コンテナをbuildし接続する

![screenshot_1638626573.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/069e2f9f-436a-c10f-8a9e-647149c92d36.png)


VSCodeでcloneしたリポジトリを開き、左下のリモートウィンドウボタンをクリックするとリモート接続のオプションが表示されるので`Reopen in Container`を選択します。

しばらく待機するとコンテナのbuildが完了しコンテナへ接続されます。


## 使い方

### AtCoderへログイン

buildがうまくいっていると、`.gitignore`に退避として設定している`login.sh`が生成されています。

`login.sh`内の

```
NAME="******"
PW="******"
```

を自身のアカウントの情報へ書き換えます。

書き換えた後に

```
$ ./login.sh
```

を実行するとログインできます。`.gitignore`に指定している通り、secretな情報になるので誤って公開情報にしないようにご注意ください。

### スニペットの作成

`snippet.py`にスニペットをお持ちの方は記載しておくと、次項のコンテストデータ作成の際にスニペットが登録された状態でファイル作成されます。

### コンテストデータの作成

コンテストが開始して問題が公開されたら`create_contest.sh`にディレクトリパス名とコンテスト名を引数として渡してコマンドを実行します。

```
$ ./create_contest.sh ${directory path} ${contest name}
```

![create_contest.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/b1a5d03e-fcd8-9dd3-5003-d0fa67892996.gif)

すると第1引数のディレクトリが作成され、その配下に第2引数のコンテストのテストケースがダウンロードされます。

![screenshot_1638611970.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/26502f27-a676-e536-6978-1f21387aae72.png)

### テストの実行

コーディングを行ってテストを行いたい場合、引数に問題のIDを追加し3つの引数を渡して実行します。

```
$ ./test.sh ${directory path} ${contest name} ${problem id}
```

![testshell.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/f6602ffb-fa04-bfc4-2825-ed0a5f4d4be2.gif)

### コードの提出

コードを提出する場合、テストの実行と同じ形式で引数を渡すとコードの提出ができます。

```
$ ./submit.sh ${directory path} ${contest name} ${problem id}
```

![submitshell.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/3da2728e-32af-3326-21e5-5ca92c9b58eb.gif)



## さいごに

みなさんよい競プロライフを!

明日は @amaguri0408さんで [デバッグを標準エラー出力で行っているという話](https://qiita.com/amaguri0408/items/61d65c3bea3a5815d704) です。

楽しみですね、よろしくお願いします!🥰
