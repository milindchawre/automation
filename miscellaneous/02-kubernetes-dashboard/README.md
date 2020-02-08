# kubernetes-dashboard
[Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) is a web-based Kubernetes user interface. You can use Dashboard to deploy containerized applications to a Kubernetes cluster, troubleshoot your containerized application, and manage the cluster resources. You can use Dashboard to get an overview of applications running on your cluster, as well as for creating or modifying individual Kubernetes resources (such as Deployments, Jobs, DaemonSets, etc).

#### Installation
- Install kubernetes dashboard.
```sh
[mchawre@ip-172-29-238-187 ~]$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
namespace/kubernetes-dashboard created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created
[mchawre@ip-172-29-238-187 ~]$
[mchawre@ip-172-29-238-187 ~]$ kubectl get ns
NAME                   STATUS   AGE
default                Active   13h
kube-system            Active   13h
kube-public            Active   13h
kube-node-lease        Active   13h
kubernetes-dashboard   Active   13s
[mchawre@ip-172-29-238-187 ~]$
[mchawre@ip-172-29-238-187 ~]$ kubectl get pods -n kubernetes-dashboard
NAME                                         READY   STATUS    RESTARTS   AGE
kubernetes-dashboard-5996555fd8-6nkks        1/1     Running   0          32s
dashboard-metrics-scraper-76585494d8-gg8g4   1/1     Running   0          32s
[mchawre@ip-172-29-238-187 ~]$ 
[mchawre@ip-172-29-238-187 ~]$ kubectl get svc -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes-dashboard        ClusterIP   10.43.142.155   <none>        443/TCP    59s
dashboard-metrics-scraper   ClusterIP   10.43.108.108   <none>        8000/TCP   59s
```
- Change service type from `clusterIP` to `NodePort`
```sh
[mchawre@ip-172-29-238-187 ~]$ kubectl -n kubernetes-dashboard edit service kubernetes-dashboard
service/kubernetes-dashboard edited
# Changed clusterIP to NodePort
[mchawre@ip-172-29-238-187 ~]$ kubectl get svc -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.43.108.108   <none>        8000/TCP        3m54s
kubernetes-dashboard        NodePort    10.43.142.155   <none>        443:31805/TCP   3m54s
[mchawre@ip-172-29-238-187 ~]$
[mchawre@ip-172-29-238-187 ~]$ curl -k https://172.29.238.187:31805
<!--
Copyright 2017 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

<!doctype html>
<html>

<head>
  <meta charset="utf-8">
  <title>Kubernetes Dashboard</title>
  <link rel="icon"
        type="image/png"
        href="assets/images/kubernetes-logo.png" />
  <meta name="viewport"
        content="width=device-width">
<link rel="stylesheet" href="styles.dd2d1d3576191b87904a.css"></head>

<body>
  <kd-root></kd-root>
<script src="runtime.380dd4d7ab4891f91b7b.js" defer></script><script src="polyfills-es5.65f1e5151c840cf04c3e.js" nomodule defer></script><script src="polyfills.8623bbc9d68876cdaaaf.js" defer></script><script src="scripts.7d5e232ea538f2c0f8a7.js" defer></script><script src="main.3036e86b43f81b098e24.js" defer></script></body>

</html>
[mchawre@ip-172-29-238-187 ~]$
```
- Configure user for kubernetes-dashboard. Refer [this](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)
```sh
[mchawre@ip-172-29-238-187 k8s]$ cat dashboard-user.yaml 
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
[mchawre@ip-172-29-238-187 k8s]$
[mchawre@ip-172-29-238-187 k8s]$ kubectl apply -f dashboard-user.yaml 
serviceaccount/admin-user created
clusterrolebinding.rbac.authorization.k8s.io/admin-user created
[mchawre@ip-172-29-238-187 k8s]$ kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
Name:         admin-user-token-pmznw
Namespace:    kubernetes-dashboard
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: admin-user
              kubernetes.io/service-account.uid: 9ee2bc29-e5ed-4aa1-92d1-26788f5b97a7

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     526 bytes
namespace:  20 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IldtX3RoMWxzdmVDWTZQQ2hvWWpnc0czVnV4SmlpeFNrME40bF9xVjB1bUUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXBtem53Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI5ZWUyYmMyOS1lNWVkLTRhYTEtOTJkMS0yNjc4OGY1Yjk3YTciLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.q3M4l9V7C8C0fTlE_NdTwOsQXc0ESPGUOYV30jHOoT_OT_82ex_menr75uDZiYveHLycE2l4sHLHjSFtjEaAshWad8Lw80l62uSxOMjpeL2m7rE_tYPzLyU1YyMzVZdhr5ONtTKw_JtViyUfOTF_XUMUgAgq-unt9aAihnTx6VLcn_upAGvd9vRCP-Z-ZMxnrj_F9pWn4avqg0pLOBuoAhyCHh8t8o__ohnWxNsT0KTI_XWXQ9j2ggeA7WMK1D8y6wvU66kpRv4BJi78vOQn-mx9N7TpSsBNyv_gdgT1j7DfK78GACMSz4zAvOtKJoluiaRg_IUt0HHYB0GG8GTwEA
[mchawre@ip-172-29-238-187 k8s]$
```
- Login to kubernetes dashboard with the token retrieved in above step.
![k8s1](https://github.com/milindchawre/automation/raw/master/miscellaneous/02-kubernetes-dashboard/images/k8s-dashboard-1.png)
![k8s2](https://github.com/milindchawre/automation/raw/master/miscellaneous/02-kubernetes-dashboard/images/k8s-dashboard-2.png)

