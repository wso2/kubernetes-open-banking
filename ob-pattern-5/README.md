# Helm Chart for deployment of WSO2 Open Banking API Manager with Identity & Access Management Module 

Resources for building a Helm chart for deployment of WSO2 Open Banking API Manager with WSO2 Open Banking Identity & Access Managment Module
support
![WSO2 Open Banking pattern 5 deployment](https://raw.githubusercontent.com/wso2/kubernetes-open-banking/v3.0.0.1/ob-pattern-5/pattern-5.png)

Note : 
  - UK toolkit is used as a reference toolkit throughout the documentation and in the sample helm chart.
  - Accelerator docker images are available at [WSO2 Private Docker Registry](https://docker.wso2.com/) and UK toolkit docker images need to be built using the accelerator docker images with the required customizations.
    - Sample Dockerfile for [wso2-obiam-toolkit-uk](https://github.com/wso2/docker-open-banking/blob/master/dockerfiles/alpine/obiam-uk/Dockerfile)
    - Sample Dockerfile for [wso2-obam-toolkit-uk](https://github.com/wso2/docker-open-banking/blob/master/dockerfiles/alpine/obam-uk/Dockerfile)
    - Reference on accelerator docker deployment, https://ob.docs.wso2.com/en/latest/install-and-setup/deploy-with-docker/
    - Reference on accelerator docker images, https://github.com/wso2/docker-open-banking/tree/master
  - UK toolkit configurations are added as Config-maps in `templates/obiam/wso2ob-pattern-5-obiam-conf.yaml` and `templates/obam/<instance-id>/wso2ob-pattern-5-obam-conf.yaml` locations.
  - These config changes need to be updated accordingly for custom toolkit deployments.

## Chart Structure

This document provides an overview of the Helm chart structure used for deploying WSO2 Open Banking API Manager with Identity & Access Management Module. Please refer to below chart structure for the customisations.

### `values.yaml`
- Contains the values used by the templates for configuring the deployment.

### `/charts`
- This directory contains the MySQL database chart used by the deployment as a dependency (`/database/mysql-ob/..`) 

### `/resources`
- Contains certificates and private keys for the servers.
    - `private-keys.jks`: Includes private keys for the servers under different aliases.
    - `public-certs.jks`: Includes public keys for each server under different aliases. These keys need to be exchanged and added to each server's trust stores.

### `/templates`
- Contains the main templates for the deployment.

  #### `wso2ob-pattern-5-carbon-certs.yaml`
    - Defines the server certificates and private keys (from the `/resources` directory) as config maps.
    - These private and public keys are added to the server in the initial start via the `wso2ob-pattern-5-obam-conf-entrypoint.yaml`.
    - Note: If adding a custom keystore and truststore as volume mappings, (Ex: `wso2carbon.jks` and `client-truststore.jks`) This step is not needed.

  #### `wso2ob-pattern-5-secret.yaml`
    - Contains Docker pull credentials as Kubernetes Secrets.

  ### `/templates/obam`
    - For **APIM Deployment Guide**: Please refer to the [APIM deployment guide](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/deployment-overview/).

      #### `wso2ob-pattern-5-obam-conf-entrypoint.yaml`
        - Contains a shell script used as the server's entrypoint. This script includes the addition of server certificates and private keys from the `/resources` directory.

      #### `wso2ob-pattern-5-obam-service.yaml`
        - Defines the common service configuration referring to individual service files located at `/<instance-id>/wso2ob-pattern-5-obam-service.yaml`.

      #### `wso2ob-pattern-5-obiam-ingress.yaml`
        - Defines the ingress to expose the APIM management console for external access on port 9443.

      #### `wso2ob-pattern-5-obam-gateway-ingress.yaml`
        - Defines the ingress to expose the HTTPS APIM gateway port for external access on port 8243.

      #### `/<instance-id>/wso2ob-pattern-5-obam-conf.yaml`
        - Contains the UK toolkit's OBAM deployment configuration as a config map for APIM HA deployment.

      #### `/<instance-id>/wso2ob-pattern-5-obam-service.yaml`
        - Contains the service configuration for the UK toolkit's OBAM deployment, exposing ports 9611, 9711, 5672, and 9443.

      #### `/<instance-id>/wso2ob-pattern-5-obam-deployment.yaml`
        - Defines the UK toolkit's OBAM deployment. The following volumes are mounted via this deployment.
            - `deployment-uk.toml`
            - `docker-entrypoint.sh`
            - `private-keys.jks`
            - `public-certs.jks`

  ### `/templates/obiam`
    - For **IS Deployment Guide**: Please refer to the [IS deployment guide](https://is.docs.wso2.com/en/6.1.0/deploy/deployment-guide/).

      #### `wso2ob-pattern-5-obiam-conf.yaml`
        - Contains the UK toolkit's OBIAM deployment configuration as a config map for HA deployment.

      #### `wso2ob-pattern-5-obiam-conf-entrypoint.yaml`
        - Contains a shell script used as the server's entrypoint, including the addition of server certificates and private keys from the `/resources` directory.

      #### `wso2ob-pattern-5-obiam-deployment.yaml`
        - Defines the UK toolkit's OBIAM deployment. The following volumes are mounted via this deployment.
            - `deployment-uk.toml`
            - `docker-entrypoint.sh`
            - `private-keys.jks`
            - `public-certs.jks`
            - `IS connector extension artifacts to run IS as the key manager` (These artifacts are downloaded through an init container and mounted to the Docker image)

      #### `wso2ob-pattern-5-obiam-service.yaml`
        - Contains the service configuration for the UK toolkit's OBIAM deployment, exposing port 9446.

      #### `wso2ob-pattern-5-obiam-ingress.yaml`
    - Defines the ingress to expose the WSO2 Identity Server (IS) for external access on port 9446.

## Contents

* [Prerequisites](#prerequisites)
* [Quick Start Guide](#quick-start-guide)
* [Configuration](#configuration)
* [Managing Java Keystores and Truststores](#managing-java-keystores-and-truststores)
* [Configuring SSL in Service Exposure](#configuring-ssl-in-service-exposure)

## Prerequisites

  For a production grade deployment of the desired WSO2 product-version, it is highly recommended to use the relevant
  OB Accelerator docker image when building the UK toolkit docker image which packages WSO2 Updates, available at [WSO2 Private Docker Registry](https://docker.wso2.com/).
  
  In order to use latest OB Accelerator docker images, you need an active [WSO2 Subscription](https://wso2.com/subscription).
  <br><br>

* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Helm](https://helm.sh/docs/intro/install/)
  and [Kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/) in order to run the steps provided in the
  following quick start guide.<br><br>

* An already setup [Kubernetes cluster](https://kubernetes.io/docs/setup).<br><br>

* Install [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/).

  Ensure that you have enabled SSL Passthrough support in the Ingress Controller. For instructions on enabling
  SSL Passthrough at the NGINX Ingress Controller, please refer to the official [documentation](https://kubernetes.github.io/ingress-nginx/user-guide/tls/#ssl-passthrough).
  <br><br>

* Add the WSO2 Helm chart repository.

    ```
     helm repo add wso2 https://helm.wso2.com && helm repo update
    ```

## Quick Start Guide

### 1. Install the Helm Chart

You can install the relevant Helm chart either from [WSO2 Helm Chart Repository](https://hub.helm.sh/charts/wso2) or by source.

**Note:**

* `NAMESPACE` should be the Kubernetes Namespace in which the resources are deployed.

#### Install Chart From [WSO2 Helm Chart Repository](https://hub.helm.sh/charts/wso2)

 Helm version 2

 ```
 helm install --name <RELEASE_NAME> wso2/ob-pattern-5 --version 3.0.0-1 --namespace <NAMESPACE> --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```


 Helm version 3

 ```
 helm install <RELEASE_NAME> wso2/ob-pattern-5 --version 3.0.0-1 --namespace <NAMESPACE> --create-namespace --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```


#### Install Chart From Source

>In the context of this document, <br>
>* `GIT_REPO` will refer to a local copy of the [`wso2/kubernetes-open-banking`](https://github.com/wso2/kubernetes-open-banking/) Git repository.
<br>

##### Clone the Helm resources for WSO2 Open Banking Git repository.

```
git clone https://github.com/wso2/kubernetes-open-banking.git
```

##### Deploy Helm chart for WSO2 Open Banking Pattern 2 deployment.

 Helm version 2

 ```
 helm install --dep-up --name <RELEASE_NAME> <GIT_REPO>/ob-pattern-5 --version 3.0.0-1 --namespace <NAMESPACE> --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```

 Helm version 3

 ```
 helm install <RELEASE_NAME> <GIT_REPO>/ob-pattern-5 --version 3.0.0-1 --namespace <NAMESPACE> --dependency-update --create-namespace --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```


### 2. Obtain the external IP

Obtain the external IP (`EXTERNAL-IP`) of the Open Banking Ingress resources, by listing down the Kubernetes Ingresses.

```  
kubectl get ing -n <NAMESPACE>
```

The output under the relevant column stands for the following.

API Manager Admin Portal, Carbon Management Console, API Publisher and Developer Portal

- NAME: Metadata name of the Kubernetes Ingress resource (defaults to `wso2ob-pattern-5-obam-ingress`)
- HOSTS: Hostname of the API Manager service (`<wso2.deployment.ob.am.ingress.management.hostname>`)
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the API Manager service to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the API Manager service

API Manager Gateway

- NAME: Metadata name of the Kubernetes Ingress resource (defaults to `wso2ob-pattern-5-obam-gateway-ingress`)
- HOSTS: Hostname of the API Manager's Gateway service (`<wso2.deployment.ob.am.ingress.gateway.hostname>`)
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the API Manager's Gateway service to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the API Manager's Gateway service

Identity & Access Management Module Carbon Management Console

- NAME: Metadata name of the Kubernetes Ingress resource (defaults to `wso2ob-pattern-5-obiam-ingress`)
- HOSTS: Hostname of the Identity & Access Management Module service (`<wso2.deployment.ob.iam.management.ingress.hostname>`)
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the Identity & Access Management Module service to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the Identity & Access Management Module service


### 3. Add a DNS record mapping the hostnames and the external IP

If the defined hostnames (in the previous step) are backed by a DNS service, add a DNS record mapping the hostnames and
the external IP (`EXTERNAL-IP`) in the relevant DNS service.

If the defined hostnames are not backed by a DNS service, for the purpose of evaluation you may add an entry mapping the
hostnames and the external IP in the `/etc/hosts` file at the client-side.

```
<EXTERNAL-IP> <wso2.deployment.ob.am.ingress.management.hostname> <wso2.deployment.ob.am.ingress.gateway.hostname> <wso2.deployment.ob.iam.management.ingress.hostname> 
```

### 4. Access Management Consoles

- API Manager Admin Portal: `https://<wso2.deployment.ob.am.ingress.management.hostname>/admin`

- API Manager Carbon Management Console: `https://<wso2.deployment.ob.am.ingress.management.hostname>/carbon`

- API Manager Publisher: `https://<wso2.deployment.ob.am.ingress.management.hostname>/publisher`

- API Manager Developer Portal: `https://<wso2.deployment.ob.am.ingress.management.hostname>/devportal`

- Identity & Access Management Module Carbon Management Console: `https://<wso2.deployment.ob.iam.ingress.management.hostname>/carbon`

Please refer the official [documentation](https://uk.ob.docs.wso2.com/en/latest/) for advanced usage details.

## Configuration

The following tables lists the configurable parameters of the chart and their default values.

###### WSO2 Subscription Configurations

| Parameter                                                       | Description                                                                               | Default Value               |
|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.subscription.username`                                    | Your WSO2 Subscription username                                                           | -                           |
| `wso2.subscription.password`                                    | Your WSO2 Subscription password                                                           | -                           |

###### Chart Dependencies

| Parameter                                                       | Description                                                                               | Default Value               |
|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.dependencies.mysql`                            | Enable the deployment and usage of WSO2 API Management MySQL based Helm Chart             | true                        |


###### API Manager Server Configurations

| Parameter                                                  | Description                                                                               | Default Value                                  |
|------------------------------------------------------------|-------------------------------------------------------------------------------------------|------------------------------------------------|
| `wso2.deployment.ob.am.dockerRegistry`                     | Registry location of the Docker image to be used to create API Manager instances          | -                                              |
| `wso2.deployment.ob.am.imageName`                          | Name of the Docker image to be used to create API Manager instances                       | `wso2-obam-toolkit-uk`                         |
| `wso2.deployment.ob.am.imageTag`                           | Tag of the image used to create API Manager instances                                     | `1.0.0.17-acc3.0.0.50-am4.2.0.41`              |
| `wso2.deployment.ob.am.imagePullPolicy`                    | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)     | `Always`                                       |
| `wso2.deployment.ob.am.livenessProbe.initialDelaySeconds`  | Initial delay for the live-ness probe for API Manager node                                | 180                                            |
| `wso2.deployment.ob.am.livenessProbe.periodSeconds`        | Period of the live-ness probe for API Manager node                                        | 10                                             |
| `wso2.deployment.ob.am.readinessProbe.initialDelaySeconds` | Initial delay for the readiness probe for API Manager node                                | 180                                            |
| `wso2.deployment.ob.am.readinessProbe.periodSeconds`       | Period of the readiness probe for API Manager node                                        | 10                                             |
| `wso2.deployment.ob.am.resources.requests.memory`          | The minimum amount of memory that should be allocated for a Pod                           | 2Gi                                            |
| `wso2.deployment.ob.am.resources.requests.cpu`             | The minimum amount of CPU that should be allocated for a Pod                              | 2000m                                          |
| `wso2.deployment.ob.am.resources.limits.memory`            | The maximum amount of memory that should be allocated for a Pod                           | 3Gi                                            |
| `wso2.deployment.ob.am.resources.limits.cpu`               | The maximum amount of CPU that should be allocated for a Pod                              | 3000m                                          |
| `wso2.deployment.ob.am.resources.jvm.heap.memory.xms`      | The initial memory allocation for JVM Heap                                                | 1024m                                          |
| `wso2.deployment.ob.am.resources.jvm.heap.memory.xmx`      | The maximum memory allocation for JVM Heap                                                | 1024m                                          |
| `wso2.deployment.ob.am.ingress.management.hostname`        | Hostname for API Manager Admin Portal, Publisher, Devportal and Carbon Management Console | `obam`                                         |
| `wso2.deployment.ob.am.ingress.management.annotations`     | Ingress resource annotations for API Manager management consoles                          | Community NGINX Ingress controller annotations |
| `wso2.deployment.ob.am.ingress.gateway.hostname`           | Hostname for API Manager Gateway                                                          | `obam-gateway`                                 |
| `wso2.deployment.ob.am.ingress.gateway.annotations`        | Ingress resource annotations for API Manager Gateway                                      | Community NGINX Ingress controller annotations |

###### IAM Module Server Configurations

| Parameter                                                   | Description                                                                                              | Default Value                                                                                   |
|-------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| `wso2.deployment.ob.iam.dockerRegistry`                     | Registry location of the Docker image to be used to create Identity & Access Management Module instances | -                                                                                               |
| `wso2.deployment.ob.iam.imageName`                          | Name of the Docker image to be used to create Identity & Access Management Module instances              | `wso2-obiam-toolkit-uk`                                                                         |
| `wso2.deployment.ob.iam.imageTag`                           | Tag of the image used to create Identity & Access Management Module instances                            | `1.0.0.21-acc3.0.0.95-is6.1.0.80-alpine`                                                        |
| `wso2.deployment.ob.iam.imagePullPolicy`                    | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)                    | `Always`                                                                                        |
| `wso2.deployment.ob.iam.replicas`                           | Number of replicas of Identity & Access Management Module                                                | 2                                                                                               |
| `wso2.deployment.ob.iam.livenessProbe.initialDelaySeconds`  | Initial delay for the live-ness probe for Identity & Access Management Module node                       | 120                                                                                             |
| `wso2.deployment.ob.iam.livenessProbe.periodSeconds`        | Period of the live-ness probe for Identity & Access Management Module node                               | 10                                                                                              |
| `wso2.deployment.ob.iam.readinessProbe.initialDelaySeconds` | Initial delay for the readiness probe for Identity & Access Management Module node                       | 120                                                                                             |
| `wso2.deployment.ob.iam.readinessProbe.periodSeconds`       | Period of the readiness probe for Identity & Access Management Module                                    | 10                                                                                              |
| `wso2.deployment.ob.iam.resources.requests.memory`          | The minimum amount of memory that should be allocated for a Pod                                          | 3Gi                                                                                             |
| `wso2.deployment.ob.iam.resources.requests.cpu`             | The minimum amount of CPU that should be allocated for a Pod                                             | 3000m                                                                                           |
| `wso2.deployment.ob.iam.resources.limits.memory`            | The maximum amount of memory that should be allocated for a Pod                                          | 4Gi                                                                                             |
| `wso2.deployment.ob.iam.resources.limits.cpu`               | The maximum amount of CPU that should be allocated for a Pod                                             | 4000m                                                                                           |
| `wso2.deployment.ob.iam.resources.jvm.heap.memory.xms`      | The initial memory allocation for JVM Heap                                                               | 2048m                                                                                           |
| `wso2.deployment.ob.iam.resources.jvm.heap.memory.xmx`      | The maximum memory allocation for JVM Heap                                                               | 2048m                                                                                           |
| `wso2.deployment.ob.iam.connector.name`                     | Name of the WSO2 IS connector                                                                            | `wso2is-extensions`                                                                             |
| `wso2.deployment.ob.iam.connector.version`                  | Version of the WSO2 IS connector                                                                         | `1.6.8`                                                                                         |
| `wso2.deployment.ob.iam.connector.url`                      | The url to download the WSO2 IS connector                                                                | `https://apim.docs.wso2.com/en/4.2.0/assets/attachments/administer/wso2is-extensions-1.6.8.zip` |
| `wso2.deployment.ob.iam.ingress.management.hostname`        | Hostname for Identity & Access Management Module service                                                 | `obiam`                                                                                         |
| `wso2.deployment.ob.iam.ingress.management.annotations`     | Ingress resource annotations for Identity & Access Management Module service                             | Community NGINX Ingress controller annotations                                                  |



####### Product Configurations

* **Data source configurations**

| Parameter                                                       | Description                                                                               | Default Value               |
|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.ob.config.datasources.rdbms.type`              | Relation Database Management System (RDBMS) type                                          | `mysql`                     |
| `wso2.deployment.ob.config.datasources.rdbms.server.hostname`   | RDBMS server hostname                                                                     | `wso2ob-rdbms-service-mysql`   |
| `wso2.deployment.ob.config.datasources.rdbms.server.port`       | RDBMS server port                                                                         | 3306                      |
| `wso2.deployment.ob.config.datasources.rdbms.server.username`   | Username of the RDBMS server user                                                         | `wso2carbon`              |
| `wso2.deployment.ob.config.datasources.rdbms.server.port`       | Password of the RDBMS server user                                                         | `wso2carbon`              |
| `wso2.deployment.ob.config.datasources.rdbms.server.port`       | JDBC driver class name to connect to the server user                                      | `com.mysql.jdbc.Driver`   |
| `wso2.deployment.ob.config.datasources.databases.*`             | Database configurations mapping to the externalized, shared data sources of the product deployment     | -            |

**Note**:

* The aforementioned externalized, product data source configurations' default values are set to those of the evaluatory, [MySQL deployment](https://hub.helm.sh/charts/wso2/mysql-ob).

* We **do not recommend** you to use the evaluatory, MySQL deployment, to host the product databases in a production grade deployment.

###### Kubernetes Specific Configurations

| Parameter                                                     | Description                                                                               | Default Value                   |
|---------------------------------------------------------------|-------------------------------------------------------------------------------------------|---------------------------------|
| `kubernetes.serviceAccount`                                   | Name of the Kubernetes Service Account to which the Pods are to be bound                  | `wso2ob-pattern-5-svc-account`  |

## Managing Java Keystores and Truststores

* By default, this deployment uses the default keystores and truststores provided by the relevant WSO2 product.

* For advanced details with regards to managing custom Java keystores and truststores in a container based WSO2 product deployment
  please refer to the [official WSO2 container guide](https://github.com/wso2/container-guide/blob/master/deploy/Managing_Keystores_And_Truststores.md).
  
## Configuring SSL in Service Exposure

* For WSO2 recommended best practices in configuring SSL when exposing the internal product services to outside of the Kubernetes cluster,
  please refer to the [official WSO2 container guide](https://github.com/wso2/container-guide/blob/master/route/Routing.md#configuring-ssl).

* Open Banking API Manager's Gateway service uses Mutual TLS (MTLS) authentication. By default, this is handled via SSL Passthrough of the Gateway Ingress.
  If you intend to configure SSL termination at the Ingress Controller level, please refer to [client certificate authentication](https://kubernetes.github.io/ingress-nginx/examples/auth/client-certs/)
  at the NGINX Ingress Controller.