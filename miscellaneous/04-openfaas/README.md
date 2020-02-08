# OpenFaaS
[OpenFaaS](https://www.openfaas.com/) - Serverless Functions Made Simple. OpenFaaS makes it easy for developers to deploy event-driven functions and microservices to Kubernetes without repetitive, boiler-plate coding. Package your code or an existing binary in a Docker image to get a highly scalable endpoint with auto-scaling and metrics.

#### Installation

- Install [faas-cli](https://github.com/openfaas/faas-cli).
```sh
awre@ip-172-29-238-187 k8s]$ curl -fsSL -o get-faas-cli.sh https://cli.openfaas.com
[mchawre@ip-172-29-238-187 k8s]$ ls
dashboard-user.yaml  get-faas-cli.sh  get_helm.sh
[mchawre@ip-172-29-238-187 k8s]$ vi get-faas-cli.sh
# Change BINLOCATION to /bin
[mchawre@ip-172-29-238-187 k8s]$ chmod +x get-faas-cli.sh 
[mchawre@ip-172-29-238-187 k8s]$ ./get-faas-cli.sh 
x86_64
Downloading package https://github.com/openfaas/faas-cli/releases/download/0.11.7/faas-cli as /home/mchawre/k8s/faas-cli
Download complete.

============================================================
  The script was run as a user who is unable to write
  to /bin. To complete the installation the
  following commands may need to be run manually.
============================================================

  sudo cp faas-cli /bin/faas-cli
  sudo ln -sf /bin/faas-cli /bin/faas
    
[mchawre@ip-172-29-238-187 k8s]$ sudo cp faas-cli /bin/faas-cli
[mchawre@ip-172-29-238-187 k8s]$ sudo ln -sf /bin/faas-cli /bin/faas
[mchawre@ip-172-29-238-187 k8s]$  
[mchawre@ip-172-29-238-187 k8s]$ faas-cli version
  ___                   _____           ____
 / _ \ _ __   ___ _ __ |  ___|_ _  __ _/ ___|
| | | | '_ \ / _ \ '_ \| |_ / _` |/ _` \___ \
| |_| | |_) |  __/ | | |  _| (_| | (_| |___) |
 \___/| .__/ \___|_| |_|_|  \__,_|\__,_|____/
      |_|

CLI:
 commit:  30b7cec9634c708679cf5b4d2884cf597b431401
 version: 0.11.7
[mchawre@ip-172-29-238-187 k8s]$
```

- Create two namespaces, one for the OpenFaaS core services and one for the functions.
```sh
[mchawre@ip-172-29-238-187 k8s]$ kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
namespace/openfaas created
namespace/openfaas-fn created
[mchawre@ip-172-29-238-187 k8s]$ 
[mchawre@ip-172-29-238-187 k8s]$ kubectl get ns
NAME                   STATUS   AGE
default                Active   47h
kube-system            Active   47h
kube-public            Active   47h
kube-node-lease        Active   47h
kubernetes-dashboard   Active   34h
openfaas               Active   6s
openfaas-fn            Active   6s
[mchawre@ip-172-29-238-187 k8s]$
```

- Install Openfaas using helm.
```sh
[mchawre@ip-172-29-238-187 k8s]$ helm repo update \
>  && helm upgrade openfaas --install openfaas/openfaas \
>     --namespace openfaas  \
>     --set functionNamespace=openfaas-fn \
>     --set generateBasicAuth=true 
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "openfaas" chart repository
Update Complete. ⎈ Happy Helming!⎈ 
Release "openfaas" does not exist. Installing it now.
NAME: openfaas
LAST DEPLOYED: Fri Feb  7 17:25:14 2020
NAMESPACE: openfaas
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
To verify that openfaas has started, run:

  kubectl -n openfaas get deployments -l "release=openfaas, app=openfaas"
To retrieve the admin password, run:

  echo $(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode)
[mchawre@ip-172-29-238-187 k8s]$
```

- Verify Openfaas installation.
```sh
[mchawre@ip-172-29-238-187 k8s]$ kubectl -n openfaas get deployments -l "release=openfaas, app=openfaas"
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
nats                1/1     1            1           27s
queue-worker        1/1     1            1           27s
alertmanager        1/1     1            1           27s
gateway             1/1     1            1           27s
basic-auth-plugin   1/1     1            1           27s
prometheus          1/1     1            1           27s
faas-idler          1/1     1            1           27s
[mchawre@ip-172-29-238-187 k8s]$ 
[mchawre@ip-172-29-238-187 k8s]$ echo $(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode)
qNZcxfQ6twFg
[mchawre@ip-172-29-238-187 k8s]$
[mchawre@ip-172-29-238-187 k8s]$ kubectl get svc -n openfaas gateway-external -o wide
NAME               TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE     SELECTOR
gateway-external   NodePort   10.43.253.239   <none>        8080:31112/TCP   9m16s   app=gateway
[mchawre@ip-172-29-238-187 k8s]$ curl http://127.0.0.1:31112
<a href="/ui/">Moved Permanently</a>.

[mchawre@ip-172-29-238-187 k8s]$

Login to openfaas using faas-cli
[mchawre@ip-172-29-238-187 k8s]$ export OPENFAAS_URL=http://127.0.0.1:31112
[mchawre@ip-172-29-238-187 k8s]$ echo $(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode)
qNZcxfQ6twFg
[mchawre@ip-172-29-238-187 k8s]$ echo -n qNZcxfQ6twFg | faas-cli login -g $OPENFAAS_URL -u admin --password-stdin
Calling the OpenFaaS server to validate the credentials...
WARNING! Communication is not secure, please consider using HTTPS. Letsencrypt.org offers free SSL/TLS certificates.
credentials saved for admin http://127.0.0.1:31112
[mchawre@ip-172-29-238-187 k8s]$ cat ~/.openfaas/config.yml 
auths:
- gateway: http://127.0.0.1:31112
  auth: basic
  token: YWRtaW46cU5aY3hmUTZ0d0Zn
[mchawre@ip-172-29-238-187 k8s]$ faas-cli version
  ___                   _____           ____
 / _ \ _ __   ___ _ __ |  ___|_ _  __ _/ ___|
| | | | '_ \ / _ \ '_ \| |_ / _` |/ _` \___ \
| |_| | |_) |  __/ | | |  _| (_| | (_| |___) |
 \___/| .__/ \___|_| |_|_|  \__,_|\__,_|____/
      |_|

CLI:
 commit:  30b7cec9634c708679cf5b4d2884cf597b431401
 version: 0.11.7

Gateway
 uri:     http://127.0.0.1:31112
 version: 0.18.10
 sha:     80b6976c106370a7081b2f8e9099a6ea9638e1f3
 commit:  Update Golang versions to 1.12


Provider
 name:          faas-netes
 orchestration: kubernetes
 version:       0.10.1 
 sha:           d39a153855c6fcdb17e5ecf4317964f2ccacb49d
[mchawre@ip-172-29-238-187 k8s]$
```

- Create a sample nodeinfo function using openfaas UI.
![openfaas-1](https://github.com/milindchawre/automation/raw/master/miscellaneous/04-openfaas/images/openfaas-1.png)

![openfaas-2](https://github.com/milindchawre/automation/raw/master/miscellaneous/04-openfaas/images/openfaas-2.png)

- Internally the function will get deployed inside a pod running in openfaas-fn namepace.
```sh
[mchawre@ip-172-29-238-187 k8s]$ kubectl get pods -n openfaas-fn
NAME                        READY   STATUS    RESTARTS   AGE
nodeinfo-6c9b69b48d-q4fc2   1/1     Running   0          2m52s
[mchawre@ip-172-29-238-187 k8s]$
```

QuickStart : [Link](https://github.com/openfaas/faas-netes/tree/master/chart/openfaas)
Types of workloads to run on top of openfaas : [Link](https://docs.openfaas.com/reference/workloads/)

