# Teleport - Gravitational

Teleportとは、[Gravitational](https://gravitational.com/)社が開発しているアクセス管理マネジメントツールである。
いわゆるSSHの踏み台サーバーとして機能し、 OktaなどのIdPを使い、SSOを使ってSSHログインすることができる。
TerminalまたはWeb UIからのアクセスすることができる。

## Teleport_Renovation CloudNative

このリポジトリは、CloudNative社がTeleportのデモ、または導入を簡易にできるように用意したコードサンプルである。

## Quick Start

### 前提

- Terraformが実行可能であること
  - AWSにTeleportの環境を用意する際に利用する。
  - [Terraform](https://github.com/cloudnative-co/teleport_renovation/tree/master/terraform)
- Ansibleが実行可能であること
  - TerraformのAWS環境のEC2インスタンスへAuth/Proxy/Nodeのセットアップを行う際に利用する。
  - 既存のインスタンスへのセットアップにも利用する。
  - [Ansible Playbook Manual](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/documents)
- AWS CLIが実行可能であると
- 対象のAWS環境の操作権限を所持し、Profile設定を行っていること
- Route53のDNSにドメインを登録済みであること
- ssh-keygen等で、ローカル環境にSSHのキーペア（秘密鍵と公開鍵）を作成、所持していること

### 手順

1. TerraformでTeleportの環境を作成する
2. AnsibleでEC2をセットアップをする
3. Adminアカウントを作成する
4. Teleportが利用可能になる

### 作成環境

- Main: Teleportを最大構成（各ロール分割）で作成した環境
- Sub: Teleportを最小構成で作成した環境

SubからMain環境へ信頼関係を結び、Main環境で統合的に管理できる環境となる。

### Terraformの実行

[Terraformの定義ファイル](https://github.com/cloudnative-co/teleport_renovation/tree/master/terraform) を使って、環境を作成する。

#### 環境変数

```bash
# 公開鍵を登録
export TF_VAR_public_key=""
# Route53に登録済みのドメインを使用
export TF_VAR_domain="teleport.example.com"
# 設定済みのProfile名を使用
export AWS_PROFILE="saml"
# リージョンを指定
export AWS_DEFAULT_REGION="ap-northeast-1"
```

#### 実行

```bash
terraform init
terraform plan
terraform apply
```

#### 各種必要となるパラメータを控える

Terraform実行時にOutputとして出力された値を利用する。

```bash
teleport_auth_server_addr
teleport_proxy_domain
teleport_cluster_name
teleport_region
teleport_bucket
```

### Ansible

#### ライセンス取得と配置

本環境は、OktaなどのIdPと連携が利用できるEnterpriseでの構築を行う。デモをリクエストし、ライセンスキーを取得する。

- [Request a Demo of Gravitational Products](https://gravitational.com/demo)

ライセンスキーはレポジトリ内に、下記のように配置する。

```
ansible/license.pem
```

### ssh_configとhostsの設定

各サーバにSSHできるようにするため、ssh_configとhostsファイルを設定する。

ssh_config

```ssh_config
########################
# Teleport Main
########################

Host teleport-bastion
  Hostname xxx.xxx.xxx.xxx

Host teleport-proxy
  Hostname xxx.xxx.xxx.xxx
  ProxyCommand ssh -W %h:%p teleport-bastion

Host teleport-auth
  Hostname xxx.xxx.xxx.xxx
  ProxyCommand ssh -W %h:%p teleport-bastion

Host teleport-node
  Hostname xxx.xxx.xxx.xxx
  ProxyCommand ssh -W %h:%p teleport-bastion

Host teleport-sub
  Hostname xxx.xxx.xxx.xxx
  User admin

########################
# Teleport Sub
########################

Host teleport-sub-node
  Hostname xxx.xxx.xxx.xxx
  ProxyCommand ssh -W %h:%p teleport-sub

Host teleport*
  User admin
  IdentityFile "~/.ssh/aws_teleport_ap-northeast-1.pem"
```

ansible/hosts

```toml
[auth-server]
teleport-auth

[proxy-server]
teleport-proxy

[node-server]
teleport-node

[sub-server]
teleport-sub

[sub-node-server]
teleport-sub-node
```

#### Main環境の構築

ansibleで利用する変数を設定する。

[ansible/vars/main.yaml](ansible/vars/main.yaml) を下記のように編集する。

```yaml
# バージョン
teleport_version: 3.0.1

# アーキテクチャ
teleport_architecture: linux-amd64

# エディション [enterprise|oss]
teleport_edition: enterprise

# インストール時の種別 [node|auth|proxy|auth-proxy]
teleport_type: ""

# エディションがenterprise時のライセンスファイルのパス
teleport_license: license.pem

# Teleportのデータディレクトリ
teleport_data_dir: /var/lib/teleport/

# typeがproxy時に指定するAuthサーバーのIPアドレス
teleport_auth_server_addr: "teleport-main-auth.teleport.example.com"

# typeがproxyもしくはauth-proxy時のdomain名
teleport_proxy_domain: "teleport.example.com"

# authサーバー作成時にのteleportのクラスター名
teleport_cluster_name: teleport-main

# リージョン
teleport_region: ap-northeast-1

# teleportで使用するS3のBucket名
teleport_bucket: teleport.example.com-teleport-main-certs

# teleportのサーバーにてLet's encrypt実行時に使用するEMmail
teleport_email: teleport@example.com

# teleportで使用するDynamoDBのデーブル名
teleport_dynamodb_table: teleport-main

# Proxy用tunnel待ち受けポート
teleport_proxy_tunnel_listen_port: 3080
```

AuthServerを構築する。

```bash
ansible-playbook -i hosts install.yaml --extra-vars  '{ "host_name" : auth-server , "teleport_type": "auth" }'
```

ProxyServerを構築する。

```bash
ansible-playbook -i hosts install.yaml --extra-vars  '{ "host_name" : proxy-server , "teleport_type": "proxy" }'
```

NodeServerを構築する。

```bash
ansible-playbook -i hosts install.yaml --extra-vars  '{ "host_name" : node-server , "teleport_type": "node" }'
```

#### Sub環境の構築

ansibleで利用する変数を設定する。

[ansible/vars/main.yaml](ansible/vars/main.yaml) を下記のように編集する。

```yaml
# バージョン
teleport_version: 3.0.1

# アーキテクチャ
teleport_architecture: linux-amd64

# エディション [enterprise|oss]
teleport_edition: enterprise

# インストール時の種別 [node|auth|proxy|auth-proxy]
teleport_type: ""

# エディションがenterprise時のライセンスファイルのパス
teleport_license: license.pem

# Teleportのデータディレクトリ
teleport_data_dir: /var/lib/teleport/

# typeがproxy時に指定するAuthサーバーのIPアドレス
teleport_auth_server_addr: "teleport-sub.teleport.example.com"

# typeがproxyもしくはauth-proxy時のdomain名
teleport_proxy_domain: "teleport-sub.teleport.example.com"

# authサーバー作成時にのteleportのクラスター名
teleport_cluster_name: teleport-main

# リージョン
teleport_region: ap-northeast-1

# teleportで使用するS3のBucket名
teleport_bucket: teleport.example.com-teleport-sub-certs

# teleportのサーバーにてLet's encrypt実行時に使用するEMmail
teleport_email: teleport@example.com

# teleportで使用するDynamoDBのデーブル名
teleport_dynamodb_table: teleport-sub

# Proxy用tunnel待ち受けポート
teleport_proxy_tunnel_listen_port: 3080
```

Auth/Proxy All-in-One Serverを構築する。

```
ansible-playbook -i hosts install.yaml --extra-vars  '{ "host_name" : sub-server , "teleport_type": "auth-proxy" }'
```

Node Serverを構築する。

```
ansible-playbook -i hosts install.yaml --extra-vars  '{ "host_name" : sub-node-server , "teleport_type": "node" }'
```

### 信頼関係の構築

ansibleで使う変数を設定する。

[ansible/vars/trusted_cluster.yaml](ansible/vars/trusted_cluster.yaml) を下記のように編集する。

```yaml
# 主となるTeleport ClusterのCluster Nameを設定
teleport_master_cluster_name: 'teleport-main'

# 主となるTeleport ClusterのProxyのIPアドレスを設定
teleport_master_cluster_addr: 'teleport.example.com'

# Proxy用tunnel待ち受けポート
teleport_proxy_tunnel_listen_port: '443'

# Proxy用WEB待ち受けポート
teleport_proxy_web_listen_port: '443'
```

信頼関係を設定する。

```bash
ansible-playbook -i hosts  trusted_cluster.yaml --extra-vars '{ "host_name" : sub-server }'
```

## 初期設定

管理者アカウントを作成する。

```bash
sudo tctl users add --roles admin admin
```

コマンド実行時にURLが作成される。そこにアクセスし、Adminアカウントを作成する。
これによって、Webコンソールからログイン可能となり、Teleportを利用することが可能になる。
