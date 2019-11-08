# Helm Chart for deployment of WSO2 Open Banking API Manager with WSO2 Open Banking Key Manager

![WSO2 Open Banking Deployment Pattern 1](images/pattern1.png)

## Contents

* [Prerequisites](#prerequisites)
* [Quick Start Guide](#quick-start-guide)

## Prerequisites

* In order to use WSO2 Open Banking Helm resources, you need an active WSO2 Open Banking subscription. If you do not possess an active WSO2 Open Banking subscription already, you can contact us from [here](https://wso2.com/solutions/financial/open-banking/).<br><br>
 
* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Helm](https://github.com/kubernetes/helm/blob/master/docs/install.md)
(and Tiller) and [Kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (compatible with v1.10) in order to run the 
steps provided in the following quick start guide.<br><br>

* An already setup [Kubernetes cluster](https://kubernetes.io/docs/setup/pick-right-solution/).<br><br>

* Install [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/). This can be easily done via
 ################
  ```
  helm install stable/nginx-ingress --name nginx-wso2ob --set rbac.create=true
  ```

## Quick Start Guide    

>In the context of this document, <br>
>* `HELM_HOME` will refer to a local copy of the [`wso2/kubernetes-open-banking`](https://github.com/wso2/kubernetes-open-banking/)
Git repository. <br>

##### 1. Clone Kubernetes Resources for WSO2 Open Banking Git repository.

```
git clone https://github.com/wso2/kubernetes-open-banking.git
```

##### 2. Setup persistent storage.

* Using [NFS Server Provisioner Stable Helm Chart](https://github.com/helm/charts/blob/master/stable/nfs-server-provisioner).
  ```
  helm install --dep-up --name wso2ob-internal-nfs <HELM_HOME>/persistent-volumes/nfs-internal-ob/ --namespace <NAMESPACE>
  ```

##### 3. Provide configurations.

a. The default product configurations are available at `<HELM_HOME>/ob-pattern-1/confs` folder. Change the
configurations as necessary.

b. Open the `<HELM_HOME>/ob-pattern-1/values.yaml` and provide the following values. 

| Parameter                       | Description                                                                               |
|---------------------------------|-------------------------------------------------------------------------------------------|
| `subscription.username`         | Your WSO2 username                                                                        |
| `subscription.password`         | Your WSO2 password                                                                        |
| `spec`                          | Your Open Banking Specification (UK/Berlin)                                               |
| `namespace`                     | Kubernetes Namespace in which the resources are deployed                                  |
| `svcaccount`                    | Kubernetes Service Account in the `namespace` to which product instance pods are attached |

##### 4. Deploy product database(s) using MySQL in Kubernetes.

```
helm install --dep-up --name wso2ob-rdbms-service-mysql <HELM_HOME>/databases/mysql-ob/ --namespace <NAMESPACE>
```

NAMESPACE should be same as in `step 2`.

For a serious deployment (e.g. production grade setup), it is recommended to connect product instances to a user owned and managed RDBMS instance.

##### 5. Access Management Console:

a. Obtain the external IP (`EXTERNAL-IP`) of the Ingress resources by listing down the Kubernetes Ingresses.

  ```
  kubectl get ing --namespac <NAMESPACE>
  ```

e.g.

```
NAME                                             HOSTS                        ADDRESS        PORTS     AGE
wso2ob-pattern-1-obam-gateway-ingress          wso2-obam-gateway           <EXTERNAL-IP>    80, 443     7m
wso2ob-pattern-1-obam-ingress                  wso2-obam                   <EXTERNAL-IP>    80, 443     7m
wso2ob-pattern-1-obkm-ingress                  wso2-obkm                   <EXTERNAL-IP>    80, 443     7m
```

b. Add the above host as an entry in /etc/hosts file as follows:

  ```
  <EXTERNAL-IP>	wso2-obam-gateway
  <EXTERNAL-IP>	wso2-obam
  <EXTERNAL-IP>	wso2-obkm
  ```

c. Try navigating to `https://wso2obam/carbon`,`https://wso2obkm/carbon`  from your favorite browser.