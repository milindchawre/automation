# Helm
[Helm](https://helm.sh/) - The package manager for Kubernetes. Helm helps you manage Kubernetes applications - Helm Charts help you define, install, and upgrade even the most complex Kubernetes application.

#### Installation

```sh
[mchawre@ip-172-29-238-187 k8s]$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
[mchawre@ip-172-29-238-187 k8s]$ ls
dashboard-user.yaml  get_helm.sh
[mchawre@ip-172-29-238-187 k8s]$ vi get_helm.sh 
# Changed HELM_INSTALL_DIR to /bin
[mchawre@ip-172-29-238-187 k8s]$ chmod +x get_helm.sh 
[mchawre@ip-172-29-238-187 k8s]$ ./get_helm.sh 
Downloading https://get.helm.sh/helm-v3.0.3-linux-amd64.tar.gz
Preparing to install helm into /bin
helm installed into /bin/helm
[mchawre@ip-172-29-238-187 k8s]$ helm version
version.BuildInfo{Version:"v3.0.3", GitCommit:"ac925eb7279f4a6955df663a0128044a8a6b7593", GitTreeState:"clean", GoVersion:"go1.13.6"}
[mchawre@ip-172-29-238-187 k8s]$
[mchawre@ip-172-29-238-187 k8s]$ helm ls
Error: Kubernetes cluster unreachable
[mchawre@ip-172-29-238-187 k8s]$ export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
[mchawre@ip-172-29-238-187 k8s]$ helm list
NAME	NAMESPACE	REVISION	UPDATED	STATUS	CHART	APP VERSION
[mchawre@ip-172-29-238-187 k8s]$
```
