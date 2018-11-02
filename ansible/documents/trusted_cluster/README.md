# Trusted Clusterの構成

![](https://gravitational.com/teleport/docs/img/tunnel.svg)

Teleportでは図のように異なるネットワーク上に存在する2つ以上のTeleport Clusterをtunnelして構成が出来ます  
手順としてはMasterとなるTeleport Clusterから認証用のTokenを発行し  
これをSlaveのTeleport Clusterに対して登録を行い  
Teleport Cluster間でtunnelして接続が可能です


1. [PlayBookのパラメーターについて](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/trusted_cluster/PARAMETERS.md)
2. [Trusted Clusterの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/trusted_cluster/CLUSTER.md)


## Trusted Clusterの構成詳細
Teleportは2つのTeleport Cluster間でTrusted Clusterを構成する際は  
MasterとなるTeleport ClusterのAuthサーバーにて発行したTrusted Cluster Tokenを、管理下に置くTeleport ClusterのAuthサーバー上で登録する事で  
Trusted ClusterのJoinを行っています。
よって、本Ansibleではこの手順を簡略化する為に以下の様な方法をとっています

![trusted_cluster.svg](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/img/trusted_cluster.svg)

Authサーバーは構築時にtokenを扱う[publish-token](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/roles/teleport-ssm-publish-tokens)を導入しています。  
publish-tokenは各種TokenをSSMにアップロードするのでMaster Teleport ClusterのTrusted ClusterはSSM上に既に存在します  

ansibleはSlaveとなるTeleport ClusterのAuthサーバーに対して、get-trusted-tokenを導入します  
導入されたget-trusted-tokenはSSMから指定されたMaster Teleport ClusterのTrusted Cluster Tokenを取得し  
設定を書き換えTrusted Clusterを構成します。
