# Trusted Clusterの構成

![](https://gravitational.com/teleport/docs/img/tunnel.svg)

Teleportでは図のように異なるネットワーク上に存在する2つ以上のTeleport Clusterを連結することでTrusted Clusterを構成できます。
Trusted Clusterは、連結するTeleport Clusterから、連結されるTeleport Clusterへ逆tunnel接続を行います。

手順としては、MasterとなるTeleport Clusterから発行した認証用のTokenを用いて、SlaveのTeleport Clusterに対して登録を行います。 

1. [PlayBookのパラメーターについて](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/trusted_cluster/PARAMETERS.md)
2. [Trusted Clusterの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/trusted_cluster/CLUSTER.md)


## Trusted Clusterの構成詳細
Teleportは、2つのTeleport Cluster間でTrusted Clusterを構成する際に、以下の手順を踏みます。

1. MasterとなるTeleport ClusterのAuthサーバーでTrusted Cluster Tokenを発行します。
2. 管理下に置くTeleport ClusterのAuthサーバー上でTrusted Cluster Tokenを登録します。

よって、本Ansibleではこの手順を簡略化する為に以下の様な方法をとっています。

![trusted_cluster.svg](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/img/trusted_cluster.svg)

Authサーバーは構築時にtokenを扱う[publish-token](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/roles/teleport-ssm-publish-tokens)を導入しています。  
publish-tokenは、各種TokenをSSMにアップロードします。
そのため、Master Teleport ClusterのTrusted Clusterは、SSMパラメータストア上に既に存在します。  

ansibleは、SlaveとなるTeleport ClusterのAuthサーバーに対して、get-trusted-tokenを導入します。 
導入されたget-trusted-tokenは、SSMパラメータストアから指定されたMaster Teleport ClusterのTrusted Cluster Tokenを取得し、設定を書き換えることで、Trusted Clusterを構成します。
