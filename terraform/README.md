# Teleport Terraform 

Teleportの構成を作成するためのTerraformサンプルとなる。
AWS上の構成を作成するのみとなり、OS内のセットアップは行わない。

- Main
Auth/Proxy/Bastion/Nodeとして役割を分割し最大構成で作成する

- Sub
1台のEC2に機能を集約し、最小構成で作成する


# 構成図
![Sample](https://github.com/cloudnative-co/teleport_renovation/blob/fa69a337471bf61c384e6c826de96ad6e9202580/Picture/Terraform_Sample.png "サンプル")

# 環境変数
```
# 公開鍵を登録
export TF_VAR_public_key=""
# Route53に登録済みのドメインを使用
export TF_VAR_domain="teleport.dev.cloudnative.co.jp"
# 設定済みのProfile名を使用
export AWS_PROFILE="saml"
# リージョンを指定
export AWS_DEFAULT_REGION="ap-northeast-1"
```

# 実行
```
terraform init
terraform plan
terraform apply
```
