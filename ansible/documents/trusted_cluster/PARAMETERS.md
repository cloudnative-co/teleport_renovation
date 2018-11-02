# パラメーター
ansibleは起動時に引数`--extra-var`に_json-format_にて外部からパラメーターの指定が可能です。
```
$ ansible-playbook --extra-vars '{ "host_name": "slave-auth" }'
```
また、`var/trusted_cluster.yaml`にて値を書き込むとその値が使用されます。  
引数 `--extra-vars`及び`var/trusted_cluster.yaml`の値が*Blank*の場合はプロンプトにて尋ねられます
`--extra-vars`にて指定された値は`vars/trusted_cluster.yaml`に値が存在しても`--extra-vars`での指定が優先されます。


| 名称 | 説明 | extra-vars指定 | trusted_cluster.yaml指定 | prompt |
| --- | --- | --- | --- | --- | --- |
| host_name | 対象となるHostを指定します | 可 | 不可 | 不可 |
| teleport_master_cluster_name | MasterとなるTeleport Clusterの名称 | 可 | 可 | Enter the Master teleport trusted cluster name |
| teleport_master_cluster_addr | MasterとなるTeleport ClusterのProxtyサーバーの接続用アドレス(ドメイン) | 可 | 可 | Enter the Master teleport proxy server IPv4 address |
| teleport_proxy_tunnel_listen_port | MasterとなるTeleport ClusterのProxtyサーバーのトンネル用Port番号 | 可 | 可 | Enter the Master teleport proxy tunnel port |
| teleport_proxy_web_listen_port| MasterとなるTeleport ClusterのProxtyサーバーのWEB用Port番号 | 可 | 可 | Enter the Master teleport proxy web port |
