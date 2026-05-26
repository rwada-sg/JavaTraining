# 研修: Java 実習用サービス加入者管理システム

このプロジェクトは、Java 実習用で使用するサービス加入者システムです。

本アプリケーションは Spring Framework 6(Spring Boot 3) を使用して作成されており、以下のパッケージを利用しています。

- Spring Web
  - Thymeleaf
- Spring Validation
- Spring Security
- Spring JDBC
  - PostgreSQL Driver
- Lombok

**本リポジトリを自分の GitHub アカウントにコピー(右上の「Use this template」→「Create a new repository」)して利用してください**

## 必要なソフトウエア

本プロジェクトの開発をするには以下のソフトウエアが必要です。

- [Visual Studio Code](https://azure.microsoft.com/ja-jp/products/visual-studio-code)
- [Git for Windows](https://gitforwindows.org/)
- [Docker Desktop](https://www.docker.com/ja-jp/products/docker-desktop/)

## 開発方法

本プロジェクトは、 Visual Studio Code(以下、VSCode) で開発することを想定しています。

1. VSCode を起動し、テンプレートから作成したリポジトリを適当な場所にクローンしてください。その後、クローンしたフォルダを開きます。
1. 初回クローンしたフォルダを VSCode で開くと、本プロジェクトが利用している拡張機能のインストールを求められますので、インストールしてください。
1. コンテナで開くかどうか効かれるので、コンテナで開いてください。(初回はコンテナのビルドが発生するため、時間がかかります。)
1. なお、開発ドキュメントは、ターミナルで `./start_docs.sh` と入力すると、Webサーバが立ち上がります。Webブラウザから [http://localhost:8000](http://localhost:8000) で参照できます。
 
## 実行およびデバッグ方法

クローンしたフォルダを VSCode で開いた状態で、F5 キーを押します。
本システムが起動したら、Webブラウザで以下のURLにアクセスします。

```URL
http://localhost:8080
```

## データベースへのアクセス

本システムは、**PostgreSQL**で動作しています。

DevContainer上では、ターミナルで以下のコマンドを入力し、パスワードを入力するとデータベースにアクセスできます。

```shell
psql -h database -U trainingapp -W trainingapp
```

### コマンドライン

以下のコマンドを実行します。

(Windows)

```
mvnw spring-boot:run -pl webapp
```

(Linux)

```
./mvnw spring-boot:run -pl webapp
```

## ビルド方法

ターミナルから以下のコマンドを実行します。

```sh
./mvnw package
```

エラーがない場合は、`webapp/target` フォルダには`webapp-0.0.1-SNAPSHOT.war` が、
`batch/target` フォルダには、`batch-0.0.1-SNAPSHOT.jar` が作成されます。

それぞれ、`java -jar <生成されたファイル>` とすることで実行できます。
