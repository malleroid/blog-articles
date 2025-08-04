---
title: GPT-3 + GASで作るSlackbot
tags:
  - GAS
  - DeepLearning
  - slackbot
  - chatbot
  - gpt-3
private: false
updated_at: '2021-12-12T12:10:00+09:00'
id: 36def200eadfce51c5f2
organization_url_name: null
slide: false
ignorePublish: false
---
## はじめに

この記事は [paiza Advent Calendar 2021](https://adventar.org/calendars/6343) 9日目の記事です。

https://adventar.org/calendars/6343

こんな感じで会話ができるようになります。優秀。
![screenshot_1638975601.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/9fdcc2dd-7b04-1f61-0f80-9b0da545ac58.png)

👈 @imaimai17468さんの前日の記事は[こちら](https://qiita.com/imaimai17468/items/8d982b91f99a698a8b6c)


## GPT-3について

GPT-3とはOpenAIが開発した文章生成言語モデルです。

公式は[こちら](https://openai.com/blog/openai-api/)

リリースされた当時は日本語は対応していませんでしたが、現在は日本語も文章生成をすることができます。

文章生成のうちで自然言語ではなくプログラムコーディングに関する部分をAPIとして切り出したのが[OpenAI Codex](https://openai.com/blog/openai-codex/)で、

さらにGithub(Microsoft)が管理しているのが[Github Copilot](https://copilot.github.com)です。
エンジニア各位が性能を体感するのに一番手っ取り早いのがCopilotを利用することだと思います。

Copilotはすごい、やばい(語彙消失)

今回は自然言語の方を体感するためにSlackbotを作ってみます。

## OpenAIに登録する


https://openai.com


[こちら](https://auth0.openai.com/u/signup)から登録できます。
つい先日までwaitlistに登録して登録時に利用目的やユーザーの身分登録が必要だったのですが、
[11/18にwaitlistなしで登録できるようになりました](https://openai.com/blog/api-no-waitlist/)

前は利用目的や申請者の情報登録が必要だったんですが...緩くなりましたね

※APIの利用は無料枠の設定があり、超過すると有料になるので注意してください。

ログイン後にAPIを利用するためのAPI KEYを作成します。
ログイン後のヘッダー右のドロップダウンメニューから`View API keys`を選択します。
![screenshot_1638684746.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/9e40feae-9aef-4946-2876-77c80a834cb1.png)

その後`Create new secret key`をクリックし、新たにAPI KEYを作成します。このAPI KEYは後で使うのでメモしておいてください。 (①)
![2021-12-05 15.12.59 beta.openai.com 2b97eb39c7d9.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/b8a5c283-eedc-438a-3686-65493d77a6c0.png)



## Slackbotを作る

3分で書いた今回の構成図はこちら
![advent.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/00a5b227-aac8-2e19-749c-ffd8cb99ed01.png)

slackの管理者権限のあるワークスペースは持っている前提で進めています。
もってない方は[公式](https://slack.com/intl/ja-jp/help/articles/206845317-Slack-%E3%83%AF%E3%83%BC%E3%82%AF%E3%82%B9%E3%83%9A%E3%83%BC%E3%82%B9%E3%82%92%E4%BD%9C%E6%88%90%E3%81%99%E3%82%8B)を参考に作成してください。

### Slackアプリを登録する

1. [Slack API](https://api.slack.com/apps)へアクセスし、`Create New App`をクリックしてアプリ名と対象のワークスペースを選択します。![2021-12-05 14.02.04 api.slack.com c7992a95232f.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/b23f9c4b-baf1-5a6a-80b0-e5fdbfa53768.png)


2. 作成したAppにスコープを追加します。左のメニューから`OAuth & Permissions`を選択し、ページ下部の`Scope`の欄に画像のように権限を追加します。
![20210313_auto_002.jpg](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/1065fdc7-0a24-8690-96d2-b2a9bcb69d52.jpeg)
![2021-12-05 14.03.57 api.slack.com 2bce80036009.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/054e6c31-5ead-a2cb-e3f1-c8c5e77f023c.png)
後でGASを作成する際に使うので、`OAuthToken`をメモしておきます。(②)
![2021-12-05 14.47.45 api.slack.com 1394d823ea70.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/22e43404-7cf1-8c70-099e-95d05f1cb0d2.png)

3. `App Home`へ遷移し、`Edit`を選択しSlackbotとして投稿する際の名前を設定します。
![2021-12-05 14.05.30 api.slack.com 4c560cfd8c5c.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/826ac139-5a56-f118-71ad-a29a62fbbebf.png)

4. `Install App`へ遷移し`Install to Workspace`を選択します。
これでWorkspaceに作成したAppがインストールされます。


### GPT-3のAPIをcallするGASを作成する。

1. [GAS](https://script.google.com/home)のhomeに行き、新しくプロジェクトを作成します。

2. [GAS to Slack を行ってくれるライブラリ](https://github.com/soundTricker/SlackApp)を追加します。
メニューからライブラリ欄の`+`を選択します。
![2021-12-05 15.04.28 script.google.com 180ef2c28fd1.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/116098e5-50c5-4404-0daf-b41171febcea.png)
表示されたウィンドウでスクリプトIDに
`1on93YOYfSmV92R5q59NpKmsyWIQD8qnoLYk-gkQBI92C58SPyA2x1-bq`と入力して検索し、出てきた`SlackApp`を追加します。
![2021-12-05 15.04.56 script.google.com a13b0f8ed8de.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/78b7d85c-214c-4300-df83-007625adef31.png)

3. コーディングとデプロイ

```
// slackに投稿する
function postSlack(e) {

  const outGoingWebHookToken = 'YOUR_OUTGOING_WEBHOOK_TOKEN'
  const slackBotToken = 'YOUR_SLACKBOT_TOKEN'

  let app = SlackApp.create(slackBotToken);
  
  if (outGoingWebHookToken != e.parameter.token) {
    console.log('invalid token');
    return
  }
  
  array = e.parameter.text.split(' ');  
  let message = '';
  if (array.length > 1) {
    message = getGpt3Message(array[1]);
  }
  
  return app.postMessage('#YOUR_CHANNEL', message , {
  });
}

// gpt-3のAPIをcallしてresponseを得る
function getGpt3Message(message) {
  var uri = 'https://api.openai.com/v1/engines/davinci/completions';

  var headers = {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-type': 'application/json'
  };

  var options = {
    'muteHttpExceptions' : true,
    'headers': headers, 
    'method': 'POST',
    'payload': JSON.stringify({
      'prompt': 'Human: ' + message + '\nAI: ', 
      'max_tokens': 30, 
      'temperature': 0.9, 
      'frequency_penalty': 0, 
      'presence_penalty': 0.6, 
      'stop': ['\n', ' Human:', 'AI: ']})
  };
  try {
      const response = UrlFetchApp.fetch(uri, options);
      var json=JSON.parse(response.getContentText());
      return json["choices"][0]["text"];
  } catch(e) {
    console.log('error');
  }
}
```
コピペしてもらえれば後はTOKENやAPI KEYを書き換えるだけで動きます。(後述します)
コードの細かい説明は省きます。GPT-3のAPIをcallする際にいくつかparameterを設定できるのでよければ調べてください。[(APIリファレンス)](https://beta.openai.com/docs/api-reference/files)

ここまで完了したらアプリをデプロイします。右上の デプロイ→新しいデプロイ を選択します。
![2021-12-05 15.30.59 script.google.com a71572d2fa85.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/fbd83e6d-f1b8-0f0f-b367-c4406673f5e1.png)
デプロイの種類をウェブアプリに設定しデプロイします。デプロイ後、ウェブアプリのURLが発行されますが後で使うのでメモします。(③)
![2021-12-05 15.31.10 script.google.com b95cd03b2933.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/47676ea7-fa6a-1772-f42f-ee5721605365.png)

### Slackの投稿をhookする設定を追加する

1. Slackのワークスペースのカスタマイズページでhookイベントを作成します。
![2021-12-05 12.48.52 app.slack.com 34504afeb4ae.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/393d50ee-a605-246b-648c-4fbf5e2add50.png)
slack app directory ページの検索欄に`outgoing`と入力して検索し`Outgoing Webhook`が表示されるので選択します。
![screenshot_1638676203.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/6467210b-c55f-2b45-6cb5-cc651d15e56e.png)
`Slackに追加`を選択すると設定項目ページへ遷移します。
![2021-12-05 13.30.32 amamotoreisen.slack.com 9942d1c4b418.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/deceb4e1-6ba5-23a4-4916-7b25e2b7b7f0.png)

2. hookイベントの設定をします。
URL欄にGASのウェブアプリURL(③のこと)を入力します。
引き金となる言葉は指定した文字列で開始した際にこのイベントがhookされるようになるので、任意に設定してください。(botへのメンションにしておくと都合がよいと思います)
トークンはこの後で使うのでメモしておいてください。(④)
![2021-12-05 16.01.47 amamotoreisen.slack.com a6f3af6acbdd.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/b5706bcb-c918-bd97-4854-1c19a3a9c3d7.png)

### GASのsecret parameterを設定する

GAS作成時に飛ばしていたparameterを設定します。

```
YOUR_OUTGOING_WEBHOOK_TOKEN // ④
YOUR_SLACKBOT_TOKEN // ②

YOUR_CHANNEL // メッセージを投稿するslack channel名

YOUR_API_KEY // ①
```

設定が完了したら保存します。

これで完成です。

## 会話してみた

それっぽいレスポンスをもらえたのを出してみました
![screenshot_1638688767.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/29327173-cee5-9b21-a6ab-d12362e138eb.png)
クッソ快晴だった、はずれ(1敗)

![screenshot_1638688781.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/cc8d66e1-a25c-1e2f-d610-8701e71e70c7.png)
パワポケRはクソゲーではありません

![screenshot_1638688792.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/f85bfdae-fc8a-aaa1-32bb-e7a1de24e530.png)
代わりに働いてほしい

![screenshot_1638688838.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/572168/31d535da-683a-5385-80d8-9ac6174fba2e.png)
尾道駅か?

一昔前のりんなちゃんくらいの精度はあるんじゃないかな...?


## さいごに

API提供されてると自分で環境を作る必要もないし、モデル作る必要もないしで楽ですね。いい世の中だぁ

OutgoingWebhook、使ってしまったけどSlack的に新APIへ移行しているようで非推奨っぽいのでそっちに寄せなきゃ...


明日は未定ですがきっと誰か書いてくれるでしょう!楽しみですね
