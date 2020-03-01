# secure-elasticsearch

This repository brings single node elasticsearch cluster on AWS with xpack security module enabled. All communications are encrypted and requires appropriate credentials to access its api. It also configures kibana with security enabled. The entire cluster is dockerized.

### Features
- [xpack](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-xpack.html) security enabled
- RAID0 of 3 EBS volume as storage for elaticsearch, this overall improves IOPS.
- Support newer storage type like [NVME](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html) volumes.
- Elasticsearch monitoring enabled on kibana.
- Completely automated using terraform and ansible. Cluster state is stored remotely in s3 bucket and terraform lock support using dyanamoDB.

### AWS Architecture
![elastic-ec2](https://github.com/milindchawre/automation/raw/master/assignments/secure-elasticsearch/images/elastic-ec2.png)

#### Pre-Requisite
On AWS you need 
- AWS access key and secret key
- pem file
- s3 bucket (Create using [this](https://github.com/milindchawre/automation/blob/master/assignments/secure-elasticsearch/infra/global/s3/README.md) )
- dynamodb table (Create using [this](https://github.com/milindchawre/automation/blob/master/assignments/secure-elasticsearch/infra/global/dynamo-db/README.md) )

On your Machine
- [Terraform](https://www.terraform.io/) (v0.12.21)
- [Ansible](https://www.ansible.com/) (2.7.2)
- [Python](https://www.python.org/) (2.7.5)

### Setting up Cluster
```
#$ git clone https://github.com/milindchawre/automation.git
#$ cd automation/assignments/secure-elasticsearch/infra/elastic

### Note: Everything runs from directory automation/assignments/secure-elasticsearch/infra/elastic

### set appropriate aws credentials
#$
#$ source creds.sh
      OR
#$ export AWS_ACCESS_KEY_ID=***************
#$ export AWS_SECRET_ACCESS_KEY=***********************
#$ export AWS_REGION=us-east-1

### Initialize terraform, set appropriate s3 bucket, dynamodb table and aws region
#$
#$ terraform init -backend-config "encrypt=true" -backend-config "bucket=elastic-terra-state-2020" -backend-config "dynamodb_table=terraform-state-lock" -backend-config "region=us-east-1" -backend-config "key=dev/terraform.tfstate"

#$ terraform plan
#$ terraform apply -auto-approve

### Wait for 10 mins before proceeeding further

### Generate ansible inventory
#$ python ../../provisioner/generate_inventory.py
### This will create ansible_inventory file in current directory

### Run ansible
### Point to appropriate location of your pem file
#$ ansible-playbook -i ansible_inventory -e "ansible_ssh_private_key_file=/path/to/us-east-1.pem" ../../provisioner/deploy.yaml
#$

### Access elasticsearch and kibana
### The ansible playbook runs print elasticsearch and kibana url at the end, similar to the one shown below.

TASK [Print elasticsearch and kibana url] ******************************************************************************
ok: [elastic-ec2] => (item=Elasticsearch URL: https://54.172.216.154:9200 [username: test and password: test123]) => {
    "msg": "Elasticsearch URL: https://54.172.216.154:9200 [username: test and password: test123]"
}
ok: [elastic-ec2] => (item=Kibana URL: https://54.172.216.154:5601 [username: test and password: test123]) => {
    "msg": "Kibana URL: https://54.172.216.154:5601 [username: test and password: test123]"
}

```

### Exploration
- Explore elasticsearch api's
```
#$ curl -k -u test:test123 https://54.172.216.154:9200
#$ curl -k -u test:test123 https://54.172.216.154:9200/_cat/nodes
#$ curl -k -u test:test123 https://54.172.216.154:9200/_cat/indices
```
- Explore kibana
```
# Explore kibana UI: https://54.172.216.154:5601 [Username: test Password: test123]
# Explore different tabs in kibana UI like monitoring, dev tools, etc
# Explore user management: Management tab in kibana allow to create different users and roles.
```

### Steps to bring down the cluster
```
#$ cd automation/assignments/secure-elasticsearch/infra/elastic
#$ terraform destroy -auto-approve
```

### Future RoadMap
- Move ElasticSearch and Kibana from public subnet to private subnet and expose it through either some reverse proxy running in public subnet or through an aws load balancer as mentioned [here](https://aws.amazon.com/premiumsupport/knowledge-center/public-load-balancer-private-ec2/).
- Dockerize the entire code, so that there is no need to install specific version of terraform, ansible and python on user machine. Only Docker installation should be sufficient.
- Extend the elasticsearch cluster from single node to multi-node.
- Cloudinit is used to configure few things like docker installation, elasticsearch config creation, etc. Move these things to ansible and keep things like RAID0 creation with cloudinit.
- The ssl certificate are not from trusted certificate authority. Make use of tools like [lets-encrypt](https://letsencrypt.org/) to created trusted ssl certificates.
- Convert ansible playbooks into ansible roles.
- Configure extra layer of security by setting up [NACL rules](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html) at subnet level.
- Harden the aws linux instance. More info [here](https://dev-sec.io/baselines/linux/).
- Make use of some dns like route53 rather than using public-ip directly to access kibana and elasticsearch.
- Write a shell script that automates the cluster creation steps.

