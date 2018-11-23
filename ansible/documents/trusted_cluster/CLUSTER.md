# Trusted Clusterの構成
1. MasterとなるTeleport ClusterとSlaveとなるTeleport Clusterを構成します<br/>構成が済んでいない場合は[teleport clusterの構成](https://github.com/cloudnative-co/teleport_renovation/tree/master/ansible/documents/teleport_cluster)を参照
2. MasterとなるTeleport ClusterのProxyサーバーのアドレス、ポート番号、クラスター名から`vars/trusted_cluster.yaml`を作成

`vars/trusted_cluster.yaml`
```
# 主となるTeleport ClusterのCluster Nameを設定
teleport_master_cluster_name: 'develop.teleport'

# 主となるTeleport ClusterのProxyのIPアドレスを設定
teleport_master_cluster_addr: '000.000.000.000'

# Proxy用tunnel待ち受けポート
teleport_proxy_tunnel_listen_port: '3080'

# Proxy用WEB待ち受けポート
teleport_proxy_web_listen_port: '3080'
```

3. SlaveとなるTeleport ClusterのAuthサーバーに対してansibleを実行
```
$ ansible-playbook trusted_cluster.yaml --extra-vars '{ "host_name" : slave-auth-server }'
```

`vars/trusted_cluster.yaml`を指定しない場合  
以下の様な`--extra-vars`の指定でも同様の動作が可能です
また、`vars/trusted_cluster.yaml`の値が全てBlank("")の場合、実行時にプロンプトにて値の入力を求められます
