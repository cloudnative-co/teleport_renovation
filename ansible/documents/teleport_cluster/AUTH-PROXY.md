# auth-proxyサーバーの構成

auth-proxyサーバーはauthとproxyの機能の双方を1台のサーバーに兼ね備えた単一のサーバーを構成します。  
同一ネットワークにteleport clusterが1セットの設計思想の場合、authサーバーとproxyサーバーを起動している場合は  
auth-proxyサーバーを構成する必要がありません。

1. ドメイン`develop.teleport.domain.co.jp`を確保しRoute53にてHosted-Zoneを作成します。
2. S3バケット、`develop.teleport.domain.co.jp-audit-session`を作成します
3. teleportの[公式サイト](https://gravitational.com/teleport/demo/)にアクセスしlicense.pemを取得しinstall.yamlと同一のパスに配置
4. EC2を起動して`auth-proxy-server`の名称でansibleのhostとして使用できるように設定する
5. `vars/main.yaml`を編集

`vars/main.yaml`
```
# インストール時の種別 [ node/auth/proxy/auth-proxy ]
teleport_type: "auth-proxy"

# typeがproxyもしくはauth-proxy時のdomain名
teleport_proxy_domain: "develop.teleport.domain.co.jp"

# authサーバー作成時にのteleportのクラスター名
teleport_cluster_name: "develop.teleport"

# teleportで使用するS3のBucket名
teleport_bucket: "develop.teleport.domain.co.jp-audit-session"

# teleportのサーバーにてLet's encrypt実行時に使用するEMmail
teleport_email: "info@domain.co.jp"

# teleportで使用するDynamoDBのデーブル名
teleport_dynamodb_table: "develop.teleport.domain.co.jp"
```

6. ansible-playbookを実行
```
$ ansible-playbook install.yaml --extra-vars '{ "host_name" : auth-proxy-server }'
```

`vars/main.yaml`を指定しない場合  
以下の様な`--extra-vars`の指定でも同様の動作が可能です
```
$ ansible-playbook install.yaml --extra-vars '{"hone_name": "auth-proxy-server", "teleport_type": "auth", "teleport_proxy_domain": "develop.teleport.domain.co.jp", "teleport_cluster_name": "develop.teleport", "teleport_bucket": "develop.teleport.domain.co.jp-audit-session", "teleport_email": "info@domain.co.jp", "teleport_dynamodb_table": "develop.teleport.domain.co.jp"}'
```
