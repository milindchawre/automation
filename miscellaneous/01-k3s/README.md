# k3s

[k3s](https://k3s.io/) is lightweight kubernetes distribution. 
More info [here](https://rancher.com/docs/k3s/latest/en/).

#### Installation
[Here](https://rancher.com/docs/k3s/latest/en/quick-start/) is the link to documentation.
- First we configure k3s-server, which runs k3s server and agent on the same node.
```sh
[mchawre@ip-172-29-238-187 ~]$ curl -sfL https://get.k3s.io | K3S_NODE_NAME=k3s-server INSTALL_K3S_BIN_DIR=/bin sh -
[INFO]  Finding latest release
[INFO]  Using v1.17.2+k3s1 as release
[INFO]  Downloading hash https://github.com/rancher/k3s/releases/download/v1.17.2+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/rancher/k3s/releases/download/v1.17.2+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  SELinux is enabled, setting permissions
which: no kubectl in (/sbin:/bin:/usr/sbin:/usr/bin)
[INFO]  Creating /usr/local/bin/kubectl symlink to k3s
which: no crictl in (/sbin:/bin:/usr/sbin:/usr/bin)
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Skipping /usr/local/bin/ctr symlink to k3s, command exists in PATH at /bin/ctr
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
[INFO]  systemd: Enabling k3s unit
Created symlink from /etc/systemd/system/multi-user.target.wants/k3s.service to /etc/systemd/system/k3s.service.
[INFO]  systemd: Starting k3s
[mchawre@ip-172-29-238-187 ~]$
[mchawre@ip-172-29-238-187 ~]$
```

- Verify your installation.
```sh
[mchawre@ip-172-29-238-187 ~]$ kubectl get nodes
WARN[2020-02-05T16:57:45.864659054Z] Unable to read /etc/rancher/k3s/k3s.yaml, please start server with --write-kubeconfig-mode to modify kube config permissions 
error: error loading config file "/etc/rancher/k3s/k3s.yaml": open /etc/rancher/k3s/k3s.yaml: permission denied
[mchawre@ip-172-29-238-187 ~]$
[mchawre@ip-172-29-238-187 ~]$ sudo chmod 777 /etc/rancher/k3s/k3s.yaml
[mchawre@ip-172-29-238-187 ~]$ kubectl get nodes
NAME         STATUS   ROLES    AGE     VERSION
k3s-server   Ready    master   2m56s   v1.17.2+k3s1
[mchawre@ip-172-29-238-187 ~]$ 
```

- Run a sample deployment on k3s.
```sh
[mchawre@ip-172-29-238-187 ~]$ kubectl get ns
NAME              STATUS   AGE
default           Active   4m34s
kube-system       Active   4m34s
kube-public       Active   4m34s
kube-node-lease   Active   4m34s
[mchawre@ip-172-29-238-187 ~]$ kubectl create ns test
namespace/test created
[mchawre@ip-172-29-238-187 ~]$ kubectl get ns
NAME              STATUS   AGE
default           Active   4m46s
kube-system       Active   4m46s
kube-public       Active   4m46s
kube-node-lease   Active   4m46s
test              Active   2s
[mchawre@ip-172-29-238-187 ~]$ kubectl run --image=nginx nginx-app --port=80 --env="DOMAIN=cluster" -n test
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/nginx-app created
[mchawre@ip-172-29-238-187 ~]$ 
[mchawre@ip-172-29-238-187 ~]$ kubectl get pods -n test
NAME                       READY   STATUS    RESTARTS   AGE
nginx-app-89cdc496-vj2zx   1/1     Running   0          47s
[mchawre@ip-172-29-238-187 ~]$ kubectl get deploy -n test
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
nginx-app   1/1     1            1           53s
[mchawre@ip-172-29-238-187 ~]$ kubectl delete deploy nginx-app -n test
deployment.apps "nginx-app" deleted
[mchawre@ip-172-29-238-187 ~]$
```

- On another node run k3s worker. For which you need to first retrieve k3s-server token.
```sh
[mchawre@ip-172-29-238-187 ~]$ sudo cat /var/lib/rancher/k3s/server/node-token
K1041722e009a5170f11571967e3a01ecec487ae8e38beb0516ec88bdf3c1142499::server:7c82d230d4eadee9dd6002ab142f3189
[mchawre@ip-172-29-238-187 ~]$ 
Run k3s-agent.
[mchawre@ip-172-29-238-187 ~]$ curl -sfL https://get.k3s.io | K3S_NODE_NAME=k3s-worker-1 INSTALL_K3S_BIN_DIR=/bin K3S_URL=https://127.0.0.1:6443 K3S_TOKEN=K1041722e009a5170f11571967e3a01ecec487ae8e38beb0516ec88bdf3c1142499::server:7c82d230d4eadee9dd6002ab142f3189 sh -
[INFO]  Finding latest release
[INFO]  Using v1.17.2+k3s1 as release
[INFO]  Downloading hash https://github.com/rancher/k3s/releases/download/v1.17.2+k3s1/sha256sum-amd64.txt
[INFO]  Skipping binary downloaded, installed k3s matches hash
[INFO]  Skipping /bin/kubectl symlink to k3s, already exists
[INFO]  Skipping /bin/crictl symlink to k3s, already exists
[INFO]  Skipping /bin/ctr symlink to k3s, already exists
[INFO]  Creating killall script /bin/k3s-killall.sh
[INFO]  Creating uninstall script /bin/k3s-agent-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s-agent.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s-agent.service
[INFO]  systemd: Enabling k3s-agent unit
Created symlink from /etc/systemd/system/multi-user.target.wants/k3s-agent.service to /etc/systemd/system/k3s-agent.service.
[INFO]  systemd: Starting k3s-agent
[mchawre@ip-172-29-238-187 ~]$ kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
k3s-server     Ready    master   10m   v1.17.2+k3s1
k3s-worker-1   Ready    node     3m    v1.17.2+k3s1
[mchawre@ip-172-29-238-187 ~]$
```

[This](https://levelup.gitconnected.com/kubernetes-cluster-with-k3s-and-multipass-7532361affa3) is a good reference.

