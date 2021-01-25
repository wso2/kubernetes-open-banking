# Helm Chart for deployment of WSO2 Open Banking API Manager with Identity & Access Management Module and Business Intelligence Support

Resources for building a Helm chart for deployment of [All-In-One WSO2 Open Banking API Manager with WSO2 Open Banking Identity & Access Managment Module
support](https://docs.wso2.com/display/OB200/Open+Banking+API+Management+High+Availability+Deployment#OpenBankingAPIManagementHighAvailabilityDeployment-DeploymentPatterns).

![WSO2 Open Banking pattern 2 deployment](https://raw.githubusercontent.com/wso2/kubernetes-open-banking/v2.0.0.1/ob-pattern-2/pattern-2.png)

For advanced details on the deployment pattern, please refer to the official [documentation](https://docs.wso2.com/display/OB200/Configuring+WSO2+Open+Banking).

## Contents

* [Prerequisites](#prerequisites)
* [Quick Start Guide](#quick-start-guide)
* [Configuration](#configuration)
* [Runtime Artifact Persistence and Sharing](#runtime-artifact-persistence-and-sharing)
* [Managing Java Keystores and Truststores](#managing-java-keystores-and-truststores)
* [Configuring SSL in Service Exposure](#configuring-ssl-in-service-exposure)

## Prerequisites

* WSO2 product Docker images used for the Kubernetes deployment.

  For a production grade deployment of the desired WSO2 product-version, it is highly recommended to use the relevant
  Docker image which packages WSO2 Updates, available at [WSO2 Private Docker Registry](https://docker.wso2.com/).
  
  In order to use these images, you need an active [WSO2 Subscription](https://wso2.com/subscription).
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
 helm install --name <RELEASE_NAME> wso2/ob-pattern-2 --version 2.0.0-1 --namespace <NAMESPACE> --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```
**Note:**

* Specification to deploy is set to Berlin by default, use following to deploy UK specification instead of Berlin for Helm version 2.

 ```
 helm install --name <RELEASE_NAME> wso2/ob-pattern-2 --version 2.0.0-1 --namespace <NAMESPACE> --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD> --set mysql-ob.wso2.deployment.spec.berlin.enabled=false --set mysql-ob.wso2.deployment.spec.uk.enabled=true
 ```

 Helm version 3

 ```
 helm install <RELEASE_NAME> wso2/ob-pattern-2 --version 2.0.0-1 --namespace <NAMESPACE> --create-namespace --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```
**Note:**

* Specification to deploy is set to Berlin by default, use following to deploy UK specification instead of Berlin for Helm version 3.

 ```
 helm install <RELEASE_NAME> wso2/ob-pattern-2 --version 2.0.0-1 --namespace <NAMESPACE> --create-namespace --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD> --set mysql-ob.wso2.deployment.spec.berlin.enabled=false --set mysql-ob.wso2.deployment.spec.uk.enabled=true
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
 helm install --dep-up --name <RELEASE_NAME> <GIT_REPO>/ob-pattern-2 --version 2.0.0-1 --namespace <NAMESPACE> --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```
**Note:**

* Specification to deploy is set to Berlin by default, use following to deploy UK specification instead of Berlin for Helm version 2.

 ```
 helm install --dep-up --name <RELEASE_NAME> <GIT_REPO>/ob-pattern-2 --version 2.0.0-1 --namespace <NAMESPACE> --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD> --set mysql-ob.wso2.deployment.spec.berlin.enabled=false --set mysql-ob.wso2.deployment.spec.uk.enabled=true
 ```

 Helm version 3

 ```
 helm install <RELEASE_NAME> <GIT_REPO>/ob-pattern-2 --version 2.0.0-1 --namespace <NAMESPACE> --dependency-update --create-namespace --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```
**Note:**

* Specification to deploy is set to Berlin by default, use following to deploy UK specification instead of Berlin for Helm version 3.

 ```
 helm install <RELEASE_NAME> <GIT_REPO>/ob-pattern-2 --version 2.0.0-1 --namespace <NAMESPACE> --dependency-update --create-namespace --set wso2.subscription.username=<SUBSCRIPTION_USERNAME> --set wso2.subscription.password=<SUBSCRIPTION_PASSWORD>
 ```

### 2. Obtain the external IP

Obtain the external IP (`EXTERNAL-IP`) of the Open Banking Ingress resources, by listing down the Kubernetes Ingresses.

```  
kubectl get ing -n <NAMESPACE>
```

The output under the relevant column stands for the following.

API Manager Admin Portal, Carbon Management Console, API Publisher and Developer Portal

- NAME: Metadata name of the Kubernetes Ingress resource (defaults to `wso2ob-pattern-2-ob-am-ingress`)
- HOSTS: Hostname of the API Manager service (`<wso2.deployment.ob.am.ingress.management.hostname>`)
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the API Manager service to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the API Manager service

API Manager Gateway

- NAME: Metadata name of the Kubernetes Ingress resource (defaults to `wso2ob-pattern-2-ob-am-gateway-ingress`)
- HOSTS: Hostname of the API Manager's Gateway service (`<wso2.deployment.ob.am.ingress.gateway.hostname>`)
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the API Manager's Gateway service to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the API Manager's Gateway service

Identity & Access Management Module Carbon Management Console

- NAME: Metadata name of the Kubernetes Ingress resource (defaults to `wso2ob-pattern-2-ob-km-ingress`)
- HOSTS: Hostname of the Identity & Access Management Module service (`<wso2.deployment.ob.km.ingress.hostname>`)
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the Identity & Access Management Module service to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the Identity & Access Management Module service

Business Intelligence (BI) Dashboard

- NAME: Metadata name of the Kubernetes Ingress resource (defaults to `wso2ob-pattern-2-ob-bi-dashboard-ingress`)
- HOSTS: Hostname of the BI Dashboard service (`<wso2.deployment.ob.bi.dashboard.ingress.hostname>`)
- ADDRESS: External IP (`EXTERNAL-IP`) exposing the BI Dashboard service to outside of the Kubernetes environment
- PORTS: Externally exposed service ports of the BI Dashboard service

### 3. Add a DNS record mapping the hostnames and the external IP

If the defined hostnames (in the previous step) are backed by a DNS service, add a DNS record mapping the hostnames and
the external IP (`EXTERNAL-IP`) in the relevant DNS service.

If the defined hostnames are not backed by a DNS service, for the purpose of evaluation you may add an entry mapping the
hostnames and the external IP in the `/etc/hosts` file at the client-side.

```
<EXTERNAL-IP> <wso2.deployment.ob.am.ingress.management.hostname> <wso2.deployment.ob.am.ingress.gateway.hostname> <wso2.deployment.ob.km.ingress.hostname> <wso2.deployment.ob.bi.dashboard.ingress.hostname>
```

### 4. Access Management Consoles

- API Manager Admin Portal: `https://<wso2.deployment.ob.am.ingress.management.hostname>/admin`

- API Manager Carbon Management Console: `https://<wso2.deployment.ob.am.ingress.management.hostname>/carbon`

- API Manager Publisher: `https://<wso2.deployment.ob.am.ingress.management.hostname>/publisher`

- API Manager Developer Portal: `https://<wso2.deployment.ob.am.ingress.management.hostname>/devportal`

- Identity & Access Management Module Carbon Management Console: `https://<wso2.deployment.ob.km.ingress.hostname>/carbon`

Please refer the official [documentation](https://docs.wso2.com/display/OB200/WSO2+Open+Banking) for advanced usage details.

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
| `wso2.deployment.dependencies.nfsProvisioner`                   | Enable the deployment and usage of NFS Server Provisioner (https://github.com/helm/charts/tree/master/stable/nfs-server-provisioner) | true |

###### Persistent Runtime Artifact Configurations

| Parameter                                                                                   | Description                                                                               | Default Value               |
|---------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.persistentRuntimeArtifacts.storageClass`                                   | Appropriate Kubernetes Storage Class                                                      | `nfs`                       |
| `wso2.deployment.persistentRuntimeArtifacts.sharedArtifacts.capacity.executionPlans`        | Capacity for execution plans shared between the Traffic Manager profile instances         | 20M                         |
| `wso2.deployment.persistentRuntimeArtifacts.sharedArtifacts.capacity.synapseConfigs`        | Capacity for synapse artifacts of APIs shared between the Gateway profile instances       | 50M                         |
| `wso2.deployment.persistentRuntimeArtifacts.sharedArtifacts.capacity.userstores`            | Capacity for secondary user stores between Identity Server instances                      | 50M                         |
| `wso2.deployment.persistentRuntimeArtifacts.apacheSolrIndexing.enabled`                     | Indicates if persistence of the runtime artifacts for Apache Solr-based indexing is enabled  | false                    |
| `wso2.deployment.persistentRuntimeArtifacts.apacheSolrIndexing.capacity.carbonDatabase`     | Capacity for persisting the H2 based local Carbon database file                           | 50M                         |
| `wso2.deployment.persistentRuntimeArtifacts.apacheSolrIndexing.capacity.solrIndexedData`    | Capacity for persisting the Apache Solr indexed data                                      | 50M                         |

###### API Manager Server Configurations

| Parameter                                                       | Description                                                                               | Default Value               |
|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.ob.am.dockerRegistry`                          | Registry location of the Docker image to be used to create API Manager instances          | -                           |
| `wso2.deployment.ob.am.imageName`                               | Name of the Docker image to be used to create API Manager instances                       | `wso2-obam`                 |
| `wso2.deployment.ob.am.imageTag`                                | Tag of the image used to create API Manager instances                                     | `2.0.0`                     |
| `wso2.deployment.ob.am.imagePullPolicy`                         | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)     | `Always`                    |
| `wso2.deployment.ob.am.livenessProbe.initialDelaySeconds`       | Initial delay for the live-ness probe for API Manager node                                | 180                         |
| `wso2.deployment.ob.am.livenessProbe.periodSeconds`             | Period of the live-ness probe for API Manager node                                        | 10                          |
| `wso2.deployment.ob.am.readinessProbe.initialDelaySeconds`      | Initial delay for the readiness probe for API Manager node                                | 180                         |
| `wso2.deployment.ob.am.readinessProbe.periodSeconds`            | Period of the readiness probe for API Manager node                                        | 10                          |
| `wso2.deployment.ob.am.resources.requests.memory`               | The minimum amount of memory that should be allocated for a Pod                           | 2Gi                         |
| `wso2.deployment.ob.am.resources.requests.cpu`                  | The minimum amount of CPU that should be allocated for a Pod                              | 2000m                       |
| `wso2.deployment.ob.am.resources.limits.memory`                 | The maximum amount of memory that should be allocated for a Pod                           | 3Gi                         |
| `wso2.deployment.ob.am.resources.limits.cpu`                    | The maximum amount of CPU that should be allocated for a Pod                              | 3000m                       |
| `wso2.deployment.ob.am.resources.jvm.heap.memory.xms`           | The initial memory allocation for JVM Heap                                                | 1024m                       |
| `wso2.deployment.ob.am.resources.jvm.heap.memory.xmx`           | The maximum memory allocation for JVM Heap                                                | 1024m                       |
| `wso2.deployment.ob.am.ingress.management.hostname`             | Hostname for API Manager Admin Portal, Publisher, Devportal and Carbon Management Console     | `am.ob.wso2.com`            |
| `wso2.deployment.ob.am.ingress.management.annotations`          | Ingress resource annotations for API Manager management consoles                          | Community NGINX Ingress controller annotations         |
| `wso2.deployment.ob.am.ingress.gateway.hostname`                | Hostname for API Manager Gateway                                                          | `gateway.am.ob.wso2.com`    |
| `wso2.deployment.ob.am.ingress.gateway.annotations`             | Ingress resource annotations for API Manager Gateway                                      | Community NGINX Ingress controller annotations         |

**Note**: The above mentioned default, minimum resource amounts for running WSO2 Open Banking API Manager server profiles are based on its [official documentation](https://apim.docs.wso2.com/en/3.1.0/install-and-setup/install/installation-prerequisites/).

###### IAM Module Server Configurations

| Parameter                                                       | Description                                                                               | Default Value               |
|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.ob.km.dockerRegistry`                          | Registry location of the Docker image to be used to create Identity & Access Management Module instances          | -                           |
| `wso2.deployment.ob.km.imageName`                               | Name of the Docker image to be used to create Identity & Access Management Module instances                       | `wso2-obiam`                 |
| `wso2.deployment.ob.km.imageTag`                                | Tag of the image used to create Identity & Access Management Module instances                                     | `2.0.0`                     |
| `wso2.deployment.ob.km.imagePullPolicy`                         | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)     | `Always`                    |
| `wso2.deployment.ob.km.replicas`                                | Number of replicas of Identity & Access Management Module                                                         | 2                           |
| `wso2.deployment.ob.km.livenessProbe.initialDelaySeconds`       | Initial delay for the live-ness probe for Identity & Access Management Module node                                | 120                         |
| `wso2.deployment.ob.km.livenessProbe.periodSeconds`             | Period of the live-ness probe for Identity & Access Management Module node                                        | 10                          |
| `wso2.deployment.ob.km.readinessProbe.initialDelaySeconds`      | Initial delay for the readiness probe for Identity & Access Management Module node                                | 120                         |
| `wso2.deployment.ob.km.readinessProbe.periodSeconds`            | Period of the readiness probe for Identity & Access Management Module                                        | 10                          |
| `wso2.deployment.ob.km.resources.requests.memory`               | The minimum amount of memory that should be allocated for a Pod                           | 3Gi                         |
| `wso2.deployment.ob.km.resources.requests.cpu`                  | The minimum amount of CPU that should be allocated for a Pod                              | 3000m                       |
| `wso2.deployment.ob.km.resources.limits.memory`                 | The maximum amount of memory that should be allocated for a Pod                           | 4Gi                         |
| `wso2.deployment.ob.km.resources.limits.cpu`                    | The maximum amount of CPU that should be allocated for a Pod                              | 4000m                       |
| `wso2.deployment.ob.km.resources.jvm.heap.memory.xms`           | The initial memory allocation for JVM Heap                                                | 2048m                       |
| `wso2.deployment.ob.km.resources.jvm.heap.memory.xmx`           | The maximum memory allocation for JVM Heap                                                | 2048m                       |
| `wso2.deployment.ob.km.ingress.hostname`                        | Hostname for Identity & Access Management Module service                                                          | `km.ob.wso2.com`            |
| `wso2.deployment.ob.km.ingress.annotations`                     | Ingress resource annotations for Identity & Access Management Module service                                      | Community NGINX Ingress controller annotations         |

**Note**: The above mentioned default, minimum resource amounts for running WSO2 Open Banking Identity & Access Management Module server profile are based on its [official documentation](https://docs.wso2.com/display/OB200/Open+Banking+Identity+and+Access+Management+High+Availability+Deployment#OpenBankingIdentityandAccessManagementHighAvailabilityDeployment-Deploymentprerequisites).

###### BI Dashboard Runtime Configurations

| Parameter                                                                 | Description                                                                                                      | Default Value               |
|---------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.ob.bi.dashboard.dockerRegistry`                          | Registry location of the Docker image to be used to create a BI Dashboard instance                               | -                           |
| `wso2.deployment.ob.bi.dashboard.imageName`                               | Name of the Docker image to be used to create a BI Dashboard instance                                            | `wso2-obbi-dashboard`       |
| `wso2.deployment.ob.bi.dashboard.imageTag`                                | Tag of the image used to create a BI Dashboard instance                                                          | `2.0.0`                     |
| `wso2.deployment.ob.bi.dashboard.imagePullPolicy`                         | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)                            | `Always`                    |
| `wso2.deployment.ob.bi.dashboard.replicas`                                | Number of replicas of BI Dashboard to be started                                                                 | 1                           |
| `wso2.deployment.ob.bi.dashboard.strategy.rollingUpdate.maxSurge`         | Refer to [doc](https://v1-14.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.14/#deploymentstrategy-v1-apps)  | 1                |
| `wso2.deployment.ob.bi.dashboard.strategy.rollingUpdate.maxUnavailable`   | Refer to [doc](https://v1-14.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.14/#deploymentstrategy-v1-apps)  | 0                |
| `wso2.deployment.ob.bi.dashboard.livenessProbe.initialDelaySeconds`       | Initial delay for the live-ness probe for BI Dashboard node                                                      | 20                          |
| `wso2.deployment.ob.bi.dashboard.livenessProbe.periodSeconds`             | Period of the live-ness probe for BI Dashboard node                                                              | 10                          |
| `wso2.deployment.ob.bi.dashboard.readinessProbe.initialDelaySeconds`      | Initial delay for the readiness probe for BI Dashboard node                                                      | 20                          |
| `wso2.deployment.ob.bi.dashboard.readinessProbe.periodSeconds`            | Period of the readiness probe for BI Dashboard node                                                              | 10                          |
| `wso2.deployment.ob.bi.dashboard.resources.requests.memory`               | The minimum amount of memory that should be allocated for a Pod                                                  | 4Gi                         |
| `wso2.deployment.ob.bi.dashboard.resources.requests.cpu`                  | The minimum amount of CPU that should be allocated for a Pod                                                     | 2000m                       |
| `wso2.deployment.ob.bi.dashboard.resources.limits.memory`                 | The maximum amount of memory that should be allocated for a Pod                                                  | 4Gi                         |
| `wso2.deployment.ob.bi.dashboard.resources.limits.cpu`                    | The maximum amount of CPU that should be allocated for a Pod                                                     | 2000m                       |
| `wso2.deployment.ob.bi.dashboard.resources.jvm.heap.memory.xms`           | The initial memory allocation for JVM Heap                                                                       | 2048m                       |
| `wso2.deployment.ob.bi.dashboard.resources.jvm.heap.memory.xmx`           | The maximum memory allocation for JVM Heap                                                                       | 2048m                       |
| `wso2.deployment.ob.bi.dashboard.config`                                  | Custom deployment configuration file (`<WSO2OB_BI>/conf/dashboard/deployment.yaml`)                              | -                           |
| `wso2.deployment.ob.bi.dashboard.ingress.hostname`                        | Hostname for BI Dashboard                                                                                        | `dashboard.bi.ob.wso2.com`  |
| `wso2.deployment.ob.bi.dashboard.ingress.annotations`                     | Ingress resource annotations for BI Dashboard                                                                    | Community NGINX Ingress controller annotations         |

###### BI Worker Runtime Configurations

| Parameter                                                              | Description                                                                                                         | Default Value               |
|------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.ob.bi.worker.dockerRegistry`                          | Registry location of the Docker image to be used to create a BI Worker instance                                     | -                           |
| `wso2.deployment.ob.bi.worker.imageName`                               | Name of the Docker image to be used to create a BI Worker instance                                                  | `wso2-obbi-worker`          |
| `wso2.deployment.ob.bi.worker.imageTag`                                | Tag of the image used to create a BI Worker instance                                                                | `2.0.0`                     |
| `wso2.deployment.ob.bi.worker.imagePullPolicy`                         | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images)                               | `Always`                    |
| `wso2.deployment.ob.bi.worker.livenessProbe.initialDelaySeconds`       | Initial delay for the live-ness probe for BI Worker node                                                            | 20                          |
| `wso2.deployment.ob.bi.worker.livenessProbe.periodSeconds`             | Period of the live-ness probe for BI Worker node                                                                    | 10                          |
| `wso2.deployment.ob.bi.worker.readinessProbe.initialDelaySeconds`      | Initial delay for the readiness probe for BI Worker node                                                            | 20                          |
| `wso2.deployment.ob.bi.worker.readinessProbe.periodSeconds`            | Period of the readiness probe for BI Worker node                                                                    | 10                          |
| `wso2.deployment.ob.bi.worker.resources.requests.memory`               | The minimum amount of memory that should be allocated for a Pod                                                     | 4Gi                         |
| `wso2.deployment.ob.bi.worker.resources.requests.cpu`                  | The minimum amount of CPU that should be allocated for a Pod                                                        | 2000m                       |
| `wso2.deployment.ob.bi.worker.resources.limits.memory`                 | The maximum amount of memory that should be allocated for a Pod                                                     | 4Gi                         |
| `wso2.deployment.ob.bi.worker.resources.limits.cpu`                    | The maximum amount of CPU that should be allocated for a Pod                                                        | 2000m                       |
| `wso2.deployment.ob.bi.worker.resources.jvm.heap.memory.xms`           | The initial memory allocation for JVM Heap                                                                          | 2048m                       |
| `wso2.deployment.ob.bi.worker.resources.jvm.heap.memory.xmx`           | The maximum memory allocation for JVM Heap                                                                          | 2048m                       |
| `wso2.deployment.ob.bi.worker.config`                                  | Custom deployment configuration file (`<WSO2OB_BI>/conf/worker/deployment.yaml`)                                    | -                           |

####### Product Configurations

* **Generic configurations**

| Parameter                                                       | Description                                                                               | Default Value               |
|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------|
| `wso2.deployment.ob.config.workflowServerURL`                   | Configure workflow server URL for signup workflow (refer to [doc](https://docs.wso2.com/display/OB200/Using+the+Signup+Workflow+for+Berlin) for Berlin specification, refer to [doc](https://docs.wso2.com/display/OB200/Using+the+Signup+Workflow+for+UK) for UK specification)  | `https://localhost:9445/services/` |

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

* For setting up databases depending on the desired PSD2 API specification, please refer to the official WSO2 Open Banking [documentation](https://docs.wso2.com/display/OB200/Configuring+WSO2+Open+Banking).

* **Berlin PSD2 specific configurations**

| Parameter                                                              | Description                                                                                 | Default Value                                                                                      |
|------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| `wso2.deployment.ob.config.berlin.payableAccountsRetrieveEndpoint`     | Configure endpoint to retrieve BERLIN payable accounts passing PSU-ID as a path parameter   | `https://wso2ob-pattern-2-ob-am-service:9443/api/openbanking/backend-berlin/services/v130/accounts/payable`   |
| `wso2.deployment.ob.config.berlin.sharableAccountsRetrieveEndpoint`    | Configure endpoint to retrieve BERLIN sharable accounts passing PSU-ID as a path parameter  | `https://wso2ob-pattern-2-ob-am-service:9443/api/openbanking/backend-berlin/services/v130/accounts/shareable` |

**Note**: Please refer to the official [documentation](https://docs.wso2.com/display/OB200/Configuring+WSO2+Open+Banking+for+Berlin) for advanced details with regards to configuring the Berlin specification.

* **UK PSD2 specific configurations**

| Parameter                                                              | Description                                                                                 | Default Value                                                                                      |
|------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| `wso2.deployment.ob.config.uk.payableAccountsRetrieveEndpoint`     | Configure endpoint to retrieve UK payable accounts passing PSU-ID as a path parameter   | `http://wso2ob-pattern-2-ob-am-service:9763/api/openbanking/backend-uk/services/bankaccounts/bankaccountservice/payable-accounts`   |
| `wso2.deployment.ob.config.uk.sharableAccountsRetrieveEndpoint`    | Configure endpoint to retrieve UK sharable accounts passing PSU-ID as a path parameter  | `http://wso2ob-pattern-2-ob-am-service:9763/api/openbanking/backend-uk/services/bankaccounts/bankaccountservice/sharable-accounts` |

**Note**: Please refer to the official [documentation](https://docs.wso2.com/display/OB200/Configuring+WSO2+Open+Banking+for+UK) for advanced details with regards to configuring the UK specification.


* **Business Intelligence configurations**

| Parameter                                                  | Description                                                                                                         | Default Value        |
|------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|----------------------|
| `wso2.deployment.ob.config.fraudDetection.enabled`         | Enable/Disable fraud detection (refer to [doc](https://docs.wso2.com/display/OB200/Working+with+Fraud+Detection))   | false                |

###### Kubernetes Specific Configurations

| Parameter                                                     | Description                                                                               | Default Value                   |
|---------------------------------------------------------------|-------------------------------------------------------------------------------------------|---------------------------------|
| `kubernetes.serviceAccount`                                   | Name of the Kubernetes Service Account to which the Pods are to be bound                  | `wso2ob-pattern-2-svc-account`  |

## Runtime Artifact Persistence and Sharing

* It is **mandatory** to set an appropriate Kubernetes StorageClass in this deployment, for persistence and sharing.

* By default, this deployment uses the `nfs` Kubernetes StorageClass created using the official, stable [NFS Server Provisioner](https://hub.helm.sh/charts/stable/nfs-server-provisioner).

* Only persistent storage solutions supporting `ReadWriteMany` [access mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)
  are applicable for `wso2.deployment.persistentRuntimeArtifacts.storageClass`.
  
* Please refer to the [official WSO2 container guide](https://github.com/wso2/container-guide/blob/master/store/Persisting_And_Sharing.md#recommended-storage-options-for-wso2-products)
  for advanced details with regards to WSO2 recommended, storage options.

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
