# Helm Chart for deployment of WSO2 Open Banking Business Intelligence module.

Resources for building a Helm chart for deployment of WSO2 Open Banking Business Intelligence module. This chart depends on the WSO2 Open Banking API Manager with WSO2 Open Banking Identity & Access Management Module helm charts.

## Contents

* [Prerequisites](#prerequisites)
* [Quick Start Guide](#quick-start-guide)
* [Configuration](#configuration)
* [Managing Java Keystores and Truststores](#managing-java-keystores-and-truststores)
* [Configuring SSL in Service Exposure](#configuring-ssl-in-service-exposure)

## Prerequisites

* Please refer to the README.md in `ob-pattern-5/README.md` on setting up WSO2 obiam and obam.

* Make sure data reporting DBs are created. ( `openbank_ob_reporting_statsdb`, `openbank_ob_reporting_summarizeddb` , `PERSISTENCE_DB` and `WSO2_CLUSTER_DB` )
  (https://apim.docs.wso2.com/en/4.0.0/install-and-setup/setup/si-deployment/deploying-si-as-minimum-ha-cluster/)

* Enable data publishing https://ob.docs.wso2.com/en/latest/get-started/data-publishing-try-out/

  * Enabling API Manager analytics in `ob-pattern-5/templates/obam/instance-1/wso2ob-pattern-5-obam-conf.yaml` and `ob-pattern-5/templates/obam/instance-2/wso2ob-pattern-5-obam-conf.yaml`: 
    ```azure
    [apim.analytics]
    enable = true
    ```
  * Enabling OB data publishing and configure the obbi server url in API Manager and IAM in `ob-pattern-5/templates/obiam/wso2ob-pattern-5-obiam-conf.yaml`, `ob-pattern-5/templates/obam/instance-1/wso2ob-pattern-5-obam-conf.yaml` and `ob-pattern-5/templates/obam/instance-2/wso2ob-pattern-5-obam-conf.yaml`:
  * This is the service URL of `obbi/obbi-HA-active-passive/templates/obbi/wso2ob-obbi-service.yaml`
    ```azure
    [open_banking.data_publishing]
    enable = true
    server_url = "{tcp://wso2ob-obbi-service:7612}"
    ```

* In this deployment pattern (active-passive), Readiness probe is defined as the the thrift data publishing port (7612), 
* This is because, we need to publish data only to the active node and only the active node open 7612 port.
* By configuring passive node is not ready , we can omit the traffic flow to passive node.

## Quick Start Guide

#### Install Chart From Source

>In the context of this document, <br>
>* `GIT_REPO` will refer to a local copy of the [`wso2/kubernetes-open-banking`](https://github.com/wso2/kubernetes-open-banking/) Git repository.
   <br>

##### Clone the Helm resources for WSO2 Open Banking Git repository.

```
git clone https://github.com/wso2/kubernetes-open-banking.git
```

##### Deploy Helm chart for WSO2 Open Banking Accelerator with OBBI Accelerator deployment.

Helm version 2

 ```
 helm install --dep-up --name <RELEASE_NAME> <GIT_REPO>/obbi/<OBBI_DEPLOYMENT_PATTERN> --version 3.0.0-1 --namespace <NAMESPACE> --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```

Helm version 3

 ```
 helm install <RELEASE_NAME> <GIT_REPO>/obbi/<OBBI_DEPLOYMENT_PATTERN> --version 3.0.0-1 --namespace <NAMESPACE> --dependency-update --create-namespace --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```

### Please refer to the README.md in `ob-pattern-5/README.md` for below steps.

2. Obtain the external IP
3. Add a DNS record mapping the hostnames and the external IP
4. Access Management Consoles

## Configuration

The following tables lists the configurable parameters of the chart and their default values.

###### WSO2 Subscription Configurations

| Parameter                                                       | Description                                                                               | Default Value               |
|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.subscription.username`                                    | Your WSO2 Subscription username                                                           | -                           |
| `wso2.subscription.password`                                    | Your WSO2 Subscription password                                                           | -                           |

###### Chart Dependencies

| Parameter                                                       | Description                                                       | Default Value               |
|-----------------------------------------------------------------|-------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.dependencies.ob-pattern-5`                     | Enable the deployment and usage of WSO2 OBIAM and OBAM Helm Chart | true                        |


###### Open Banking Business Intelligence Server Configurations

| Parameter                                                  | Description                                                                           | Default Value              |
|------------------------------------------------------------|---------------------------------------------------------------------------------------|----------------------------|
| `wso2.deployment.ob.bi.dockerRegistry`                     | Registry location of the Docker image to be used to create OBBI instances             | -                          |
| `wso2.deployment.ob.bi.imageName`                          | Name of the Docker image to be used to create OBBI instances                          | `wso2-obbi`                |
| `wso2.deployment.ob.bi.imageTag`                           | Tag of the image used to create OBBI instances                                        | `3.0.0.0-si4.0.0.0-alpine` |
| `wso2.deployment.ob.bi.imagePullPolicy`                    | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images) | `Always`                   |
| `wso2.deployment.ob.bi.livenessProbe.initialDelaySeconds`  | Initial delay for the live-ness probe for OBBI node                                   | 20                         |
| `wso2.deployment.ob.bi.livenessProbe.periodSeconds`        | Period of the live-ness probe for OBBI node                                           | 10                         |
| `wso2.deployment.ob.bi.readinessProbe.initialDelaySeconds` | Initial delay for the readiness probe for OBBI node                                   | 20                         |
| `wso2.deployment.ob.bi.readinessProbe.periodSeconds`       | Period of the readiness probe for OBBI node                                           | 10                         |
| `wso2.deployment.ob.bi.resources.requests.memory`          | The minimum amount of memory that should be allocated for a Pod                       | 4Gi                        |
| `wso2.deployment.ob.bi.resources.requests.cpu`             | The minimum amount of CPU that should be allocated for a Pod                          | 2000m                      |
| `wso2.deployment.ob.bi.resources.limits.memory`            | The maximum amount of memory that should be allocated for a Pod                       | 4Gi                        |
| `wso2.deployment.ob.bi.resources.limits.cpu`               | The maximum amount of CPU that should be allocated for a Pod                          | 2000m                      |
| `wso2.deployment.ob.bi.resources.jvm.heap.memory.xms`      | The initial memory allocation for JVM Heap                                            | 3048m                      |
| `wso2.deployment.ob.bi.resources.jvm.heap.memory.xmx`      | The maximum memory allocation for JVM Heap                                            | 3048m                      |

### Please refer to the README.md in `ob-pattern-5/README.md` for API Manager Server Configurations, IAM Module Server Configurations and Product Configurations.

**Note**:

* The aforementioned externalized, product data source configurations' default values are set to those of the evaluatory, [MySQL deployment](https://hub.helm.sh/charts/wso2/mysql-ob).

* We **do not recommend** you to use the evaluatory, MySQL deployment, to host the product databases in a production grade deployment.

###### Kubernetes Specific Configurations

| Parameter                                                     | Description                                                                               | Default Value             |
|---------------------------------------------------------------|-------------------------------------------------------------------------------------------|---------------------------|
| `kubernetes.serviceAccount`                                   | Name of the Kubernetes Service Account to which the Pods are to be bound                  | `wso2ob-obbi-svc-account` |

### Please refer to the README.md in `ob-pattern-5/README.md` for below steps.

* Managing Java Keystores and Truststores
* Configuring SSL in Service Exposure

