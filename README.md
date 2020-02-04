# automation

#### Pre-Requisite
On AWS you need 
- pem file
- s3 bucket
- dynamodb table

#### BringUp Steps
```sh
$ cd terraform
$ source creds.sh
$ terraform init -backend-config "encrypt=true" -backend-config "bucket=terrastate2020" -backend-config "dynamodb_table=terraform-lock-dynamo" -backend-config "region=us-east-1" -backend-config "key=test/terraform.tfstate"
$ terraform plan
$ terraform apply
```

#### Post-Bringup Steps
1. Login to jenkins http://<ci-cd-machine-ip>:8080
2. Configure jenkins.
3. Create a pipeline job using Jenkinsfile commited in this repository.
4. Trigger the job to configure a web-server.

