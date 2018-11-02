# Teleport Clusterの構成

![](https://gravitational.com/teleport/docs/img/overview.svg)

図のようにteleportはProxy,Auth,Nodeの構成にて一つのClusterを構成します。  
本稿では、ansibleを用いてEC2に対してauth, proxy, nodeをそれぞれ構成していきます。

1. [PlayBookのパラメーターについて](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/PARAMETERS.md)
2. [authサーバーの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/AUTH.md)
3. [proxyサーバーの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/PROXY.md)
3. [nodeサーバーの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/NODE.md)
