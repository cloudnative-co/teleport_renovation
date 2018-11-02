# パラメーター
ansibleは起動時に引数`--extra-var`に_json-format_にて外部からパラメーターの指定が可能です。
```
$ ansible-playbook --extra-vars '{ "host_name": "auth-server", "teleport_type": "auth" }'
```
また、`var/main.yaml`にて値を書き込むとその値が使用されます。  
引数 `--extra-vars`及び`var/main.yaml`の値が*Blank*の場合は`/defaults/main.yaml`に記載された値が使用されます。  
引数 `--extra-vars`、`var/main.yaml`、`/defaults/main.yaml`のが全て*Blank*の際は実行時に画面上のプロンプトにて問い合わせが行われます  
`--extra-vars`にて指定された値は`vars/main.yaml`に値が存在しても`--extra-vars`での指定が優先されます。


| 名称 | 説明 | extra-vars指定 | main.yaml指定 | default | prompt |
| --- | --- | --- | --- | --- | --- |
| host_name | 対象となるHostを指定します | 可 | 不可 | 不可 | 不可 |
| teleport_version | teleportのバージョン | 可 | 可 | 3.0.1 | Enter the teleport version [ex) 3.0.0-rc.6] |
| teleport_architecture | teleportのアーキテクチャ | 可 | 可 | linux-amd64 | Enter the teleport architecture [ex) linux-amd64 ] |
| teleport_edition | teleportのエディション(enterprise / oss) | 可 | 可 | enterprise | Enter the teleport edition [enterprise/oss] |
| teleport_type | 構成するteleportの種類(auth/proxy/node/auth-proxy) | 可 | 可 | "" | Enter the teleport type [auth/proxy/auth-proxy/node] |
| teleport_license | teleportのライセンスファイルの場所<br/>ansibleから参照可能な場所に配置してください | 可 | 可 | license.pem | Enter the teleport license file path |
| teleport_data_dir | teleportのデータ保存先ディレクトリ | 可 | 可 | /var/lib/teleport/ |  Enter the teleport data directory path |
| teleport_auth_server_addr | authサーバーのIPアドレス<br/>proxサーバーやnodeサーバー構成時に使用します | 可 | 可 | "" | Enter the auth server address |
| teleport_proxy_domain | proxyサーバーが使用するdomain名 | 可 | 可 | "" | Enter the teleport domain name |
| teleport_cluster_name | 構成するteleport clusterの名称 | 可 | 可 | "" | Enter the teleport cluster name |
| teleport_region | DynamoDB及びSSMにて使用するawsのリージョン | 可 | 可 | ap-northeast-1 | Enter the aws region |
| teleport_bucket | 使用するS3 Bucket名 | 可 | 可 | "" | Enter the S3 bucket name |
| teleport_email | 証明書取得時に使用するemailアドレス | 可 | 可 | "" | Enter the Let's encrypt e-mail address |
| teleport_dynamodb_table | 作成するDyanmoDBテーブル名 | 可 | 可 | "" | Enter the DynamoDB table name |
| teleport_storage | authサーバーが使用するストレージ情報 | 可 | 可 | type: dynamodb<br/>region: "{{ teleport_region }}"<br/>table_name: "{{ teleport_dynamodb_table }}"<br/>audit_events_uri: "dynamodb://{{ teleport_dynamodb_table }}-events"<br/>audit_sessions_uri: "s3://{{ teleport_bucket }}/records" | 不可 |
| teleport_node_ssh_service_port | ノード用SSHポート | 可 | 可 | 3022 | --- |
| teleport_proxy_ssh_listen_port | Proxy用SSHポート | 可 | 可 | 3023 | --- |
| teleport_proxy_tunnel_listen_port | Proxy用tunnel待ち受けポート | 可 | 可 | 3024 | --- |
| teleport_auth_api_listen_port | Auth用api待ち受けポート | 可 | 可 | 3025 | --- |
| teleport_proxy_web_listen_port |Proxy用WEB待ち受けポート  | 可 | 可 | 3080 | --- |
