# Trusted Clusterの構成

![](https://gravitational.com/teleport/docs/img/tunnel.svg)

Teleportでは図のように異なるネットワーク上に存在する2つ以上のTeleport Clusterをtunnelして構成が出来ます  
手順としてはMasterとなるTeleport Clusterから認証用のTokenを発行し  
これをSlaveのTeleport Clusterに対して登録を行い  
Teleport Cluster間でtunnelして接続が可能です


1. [PlayBookのパラメーターについて](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/trusted_cluster/PARAMETERS.md)
