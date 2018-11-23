# teleport installer for ansible

## はじめに
本稿は、ansibleを用いてGRAVITATIONAL Teleportを構成するansibleのplaybookの使用方法について説明を行います。

## 対象
本ソフトウェアはansible及び、AWSに対して一定の理解のある者を対象とします。

## 用語
| 名称 | 説明 |
| --- | --- |
| authサーバー | teleport認証用サーバーを指します |
| proxyサーバー | teleportのWEBコンソール及びnodeサーバーへの接続ルーティング用サーバーを指します |
| nodeサーバー | teleportを用いてコンソール接続を行う対象のサーバーを指します |
| auth-proxyサーバー | 上記、authサーバーとproxyサーバーの機能を1台に兼用させたサーバーを指します |
| teleport cluster | authサーバー、proxyサーバー、nodeサーバーにて構成される<br />teleportの動作セットを指します |
| trusted cluster | 2つ以上のteleport clusterを接続し  master/slaveの関係を構築しslaveのteleport clusterをmasterのteleport clusterの配下に配置する事を指します |

## 環境条件
### ansible動作条件
* versionは2.7以降である事
* ansibleの動作環境にpython-aptが動作する事
* ansibleの動作環境にてawscliの動作が行える事

### 使用するSaaS
| 名称 | 補足 |
| --- | --- |
| Let's Encrypt | Proxyサーバー用の証明書をauthサーバーにて発行します |
| Amazon S3| 事前に空のBucket作成しておくこと  teleportのaudit-sessionと証明書情報が保存されます |
| Amazon DynamoDB | 使用するTableが存在しないこと  初回起動時に自動的に作成します。</br>authサーバーのストレージ及び、Lock情報が保存されます |
| AWS Systems Manager | サーバー間でのtokenの受け渡しに使用します |
| Amazon Route53 | 事前にHosted-Zoneを作成し、所有しているDomainをホストしておくこと |
| Amazon EC2 | ansibleの構成対象となるhostはec2上での動作を前提とします。  また事前に対象となるhostをec2にて起動しておくこと |

### インフラ条件
* 対象hostはdebian-stretch-hvm-x86_64-gp2-2018-08-14-82175-572488bb-fc09-4638-8628-e1e1d26436f4-ami-00bbb68c7e6ca73ce.4 (ami-0b47ed98608f1b8a4)上での動作を前提に検証を行っています
* 対象となるhostはsystemdが動作している事
* 対象hostに対してAWS IAM Roleが割り振られ[既定の権限](https://github.com/cloudnative-co/teleport_renovation/tree/master/manual-deploy/iam)が存在する事
* 構築するサーバーの種別に応じたSecurityGroupを設定する事[PORTS](https://gravitational.com/teleport/docs/admin-guide/#ports)
* 使用するDomainをあらかじめ取得し、Amazon Route53にHosted-Zoneを作成


### 実行方法
[teleport clusterの構成](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/documents/teleport_cluster)  
[trusted clusterの構成](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/documents/trusted_cluster)
