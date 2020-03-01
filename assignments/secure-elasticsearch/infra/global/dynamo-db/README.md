# dynamodb table for terraform locks

```
### Set appropriate aws creds in creds.sh file

#$ source creds.sh
#$ terraform init
#$ terraform apply

```

This should create dynamodb table (terraform-state-lock) in aws which will be used to lock terraform execution.

