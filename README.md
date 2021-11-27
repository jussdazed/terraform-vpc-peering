# Terraform cross-region peering with remote state


### Установка


Клонируем проект:
```sh
git clone git@github.com:jussdazed/terraform-vpc-peering.git
```
или
```sh
git clone https://github.com/jussdazed/terraform-vpc-peering.git
```

В папке s3_storage производим инициализацию и создаем s3 и dynamodb:
```sh
terraform init
terraform apply
```

В папке main производим инициализацию и создаем vpc, subnet, ec2 в регионах frankfurt & ireland:
```sh
terraform init
terraform apply
```





