# Teleport Clusterの構成

![](https://gravitational.com/teleport/docs/img/overview.svg)

図のようにteleportはProxy,Auth,Nodeの構成にて一つのClusterを構成します。  
本稿では、ansibleを用いてEC2に対してauth, proxy, nodeをそれぞれ構成していきます。



1. [PlayBookのパラメーターについて](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/PARAMETERS.md)
2. [authサーバーの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/AUTH.md)
3. [proxyサーバーの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/PROXY.md)
3. [nodeサーバーの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/NODE.md)
4. [auth-proxyサーバーの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/AUTH-PROXY.md)

## Teleport Clusterの構成詳細
TeleportはAuthサーバーにて発行したTokenをProxy、Nodeの設定ファイル書き込み
Teleportを起動する事でAuth⇔Proxy、Auth⇔NodeのJoinを行っています。
本Ansibleではこの手順を簡略化する為に以下の様な方法をとっています

![teleport_cluster.svg](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/img/teleport_cluster.svg)

上図はTeleport Clusterのシンプルな構成です  
1. Authサーバー
  1. authサーバーは構築時に同時に証明書を扱う[get-cert](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/roles/teleport-get-cert)とtokenを扱う[publish-token](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/roles/teleport-ssm-publish-tokens)を導入します。  
  2. get-certは実行時にLet's Encryptにアクセスを行い指定のドメインの**証明書を取得しS3バケットにアップロード**します
  3. publish-tokenは実行時にtctlを実行しTeleportのサーバーからProxy,Node,Trusted用の**各tokenとCAを取得しSSMにアップロード**します
2. Proxyサーバー

  1. Proxyサーバーを構築時に[push-cert](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/roles/teleport-push-cert)と[get-token](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/roles/teleport-ssm-get-token)が導入されます
  2. push-certは実行時に**S3バケットから証明書をダウンロード**してProxyサーバーのWEB証明書として使用します。
  3. get-tokenは実行時に**SSMからProxy TokenとCAをダウンロード**します
  4. teleportは2、3で取得したTokenとCAを使用してProxyサーバーとしてAuthサーバーに紐づきます

2. Proxyサーバー

  1. Proxyサーバーを構築時に[get-token](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/roles/teleport-ssm-get-token)が導入されます
  2. get-tokenは実行時に**SSMからNode Tokenをダウンロード**します
  3. teleportは2で取得したTokenを使用してNodeサーバーとしてAuthサーバーに紐づきます
