# Nodeサーバーの構成

前提としてauthサーバーとproxyサーバーの構成が完了しているものとして進めます。  
完了していない場合は、[authサーバーの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/AUTH.md)と
[proxyサーバーの構成](https://github.com/cloudnative-co/teleport_renovation/blob/master/ansible/documents/teleport_cluster/PROXY.md)を先に実行してください

1. authサーバーのIPアドレスを取得してください
2. EC2を起動して`node-server`の名称でansibleのhostとして使用できるように設定する
3. `vars/main.yaml`を編集

`vars/main.yaml`
```
# インストール時の種別 [ node/auth/proxy/auth-proxy ]
teleport_type: "node"

# typeがproxyもしくはauth-proxy時のdomain名
teleport_proxy_domain: "develop.teleport.domain.co.jp"

# authサーバー作成時にのteleportのクラスター名
teleport_cluster_name: "develop.teleport"

teleport_auth_server_addr: "0.0.0.0" # ← ここにauthサーバーのIPアドレスを指定

# teleportで使用するS3のBucket名
teleport_bucket: "develop.teleport.domain.co.jp-audit-session"

# teleportのサーバーにてLet's encrypt実行時に使用するEMmail
teleport_email: "info@domain.co.jp"

# teleportで使用するDynamoDBのデーブル名
teleport_dynamodb_table: "develop.teleport.domain.co.jp"
```

4. ansible-playbookを実行

```
$ ansible-playbook install.yaml --extra-vars '{ "host_name" : node-server }'
```
