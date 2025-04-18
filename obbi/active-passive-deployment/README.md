# Helm Chart for deployment of WSO2 Open Banking UK Toolkit Business Intelligence module.

Resources for building a Helm chart for deployment of WSO2 Open Banking UK Toolkit Business Intelligence module. This chart depends on the WSO2 Open Banking UK Toolkit API Manager with WSO2 Open Banking UK Toolkit Identity & Access Management Module helm charts.

Note:
- UK toolkit (OBBI) is used as a reference toolkit throughout the documentation and in the sample helm chart.
- Accelerator docker (OBBI) images are available at [WSO2 Private Docker Registry](https://docker.wso2.com/) and UK toolkit (OBBI) docker images need to be built using the accelerator docker images with the required customizations.
  - Sample Dockerfile for [wso2-obbi-toolkit-uk](https://github.com/wso2/docker-open-banking/blob/master/dockerfiles/alpine/obbi-uk/Dockerfile)
- Reference on accelerator docker deployment, https://ob.docs.wso2.com/en/latest/install-and-setup/deploy-with-docker/
- Reference on accelerator docker images, https://github.com/wso2/docker-open-banking/tree/master

## Chart Structure

This document provides an overview of the Helm chart structure used for deploying WSO2 Open Banking UK Toolkit Business Intelligence module. Please refer to below chart structure for the customisations.

### `values.yaml`
- Contains the values used by the templates for configuring the deployment.

### `/charts`
- This directory contains the ob-pattern-5 (UK Toolkit OBIAM and OBAM) chart used by the deployment as a dependency (`ob-pattern-5/..`)

### `/resources`
- Contains certificates and private keys for the servers.
  - `private-keys.jks`: Includes private key for the wso2-obbi-toolkit-uk server.
  - `public-certs.jks`: Includes public keys for wso2-obbi-toolkit-uk server. These keys need to be exchanged and added to each server's (obiam, obam and obbi) truststore.

### `/templates`
- Contains the main templates for the deployment.

  #### `wso2ob-obbi-carbon-certs.yaml`
  - Defines the server certificates and private keys (from the `/resources` directory) as config maps.
  - These private and public keys are added to the server in the initial start via the `wso2ob-obbi-conf-entrypoint.yaml`.
  - Note: If adding a custom keystore and truststore as volume mappings, (Ex: `wso2carbon.jks` and `client-truststore.jks`) This step is not needed.

  #### `wso2ob-pattern-5-secret.yaml`
  - Contains Docker pull credentials as Kubernetes Secrets.

  ### `/templates/obbi`
  - For **Streaming Integrator Deployment Overview**: Please refer to the [Streaming Integrator Deployment Overview](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/si-deployment/deployment-guide/).

    #### `wso2ob-obbi-conf-entrypoint.yaml`
    - Contains a shell script used as the server's entrypoint. This script includes the addition of server certificates and private keys from the `/resources` directory.

    #### `/instance-<id>/wso2ob-obbi-conf.yaml`
    - Contains the UK toolkit's OBBI deployment.yaml configuration as a config map for the deployment.

    #### `/instance-<id>/wso2ob-obbi-service.yaml`
    - Contains the service configuration for the UK toolkit's OBBI deployment.

    #### `/instance-<id>/wso2ob-obbi-deployment.yaml`
    - Defines the UK toolkit's OBAM deployment. The following volumes are mounted via this deployment.
      - `deployment-uk.yaml`
      - `docker-entrypoint.sh`
      - `private-keys.jks`
      - `public-certs.jks`

## Contents

* [Prerequisites](#prerequisites)
* [Quick Start Guide](#quick-start-guide)
* [Configuration](#configuration)
* [Managing Java Keystores and Truststores](#managing-java-keystores-and-truststores)
* [Configuring SSL in Service Exposure](#configuring-ssl-in-service-exposure)

## Prerequisites

* Please refer to the README.md in `ob-pattern-5/README.md` on setting up WSO2 obiam and obam.

* Make sure data reporting DBs are created. ( `openbank_ob_reporting_statsdb`, `openbank_ob_reporting_summarizeddb` , `PERSISTENCE_DB` and `WSO2_CLUSTER_DB` )
  (https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/si-deployment/deploying-si-as-minimum-ha-cluster/)

* Enable data publishing https://ob.docs.wso2.com/en/latest/get-started/data-publishing-try-out/

  * Enabling API Manager analytics in `ob-pattern-5/templates/obam/instance-1/wso2ob-pattern-5-obam-conf.yaml` and `ob-pattern-5/templates/obam/instance-2/wso2ob-pattern-5-obam-conf.yaml`: 
    ```azure
    [apim.analytics]
    enable = true
    ```
  * Enabling OB data publishing and configure the obbi server urls in API Manager and IAM in `ob-pattern-5/templates/obiam/wso2ob-pattern-5-obiam-conf.yaml`, `ob-pattern-5/templates/obam/instance-1/wso2ob-pattern-5-obam-conf.yaml` and `ob-pattern-5/templates/obam/instance-2/wso2ob-pattern-5-obam-conf.yaml`:
  * This is the service URL of `obbi/active-passive-deployment/templates/obbi/instance-1/wso2ob-obbi-service.yaml` and `obbi/active-passive-deployment/templates/obbi/instance-2/wso2ob-obbi-service.yaml`
    ```azure
    [open_banking.data_publishing]
    enable = true
    server_url = "{tcp://wso2ob-obbi-1-service:7612|tcp://wso2ob-obbi-2-service:7612}"
    ```

* Here we are adding two thrift data publishing urls of obbi, If one is unreachable then it tries the 2nd url.
* In this deployment, readiness probe is defined as port 9443.

## Quick Start Guide

#### Install Chart From Source

>In the context of this document, <br>
>* `GIT_REPO` will refer to a local copy of the [`wso2/kubernetes-open-banking`](https://github.com/wso2/kubernetes-open-banking/) Git repository.
   <br>

##### Clone the Helm resources for WSO2 Open Banking Git repository.

```
git clone https://github.com/wso2/kubernetes-open-banking.git
```

##### Deploy Helm chart for WSO2 Open Banking UK Toolkit with OBBI deployment.

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

| Parameter                                                  | Description                                                                           | Default Value                  |
|------------------------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------|
| `wso2.deployment.ob.bi.dockerRegistry`                     | Registry location of the Docker image to be used to create OBBI instances             | -                              |
| `wso2.deployment.ob.bi.imageName`                          | Name of the Docker image to be used to create OBBI instances                          | `wso2-obbi-toolkit-uk`         |
| `wso2.deployment.ob.bi.imageTag`                           | Tag of the image used to create OBBI instances                                        | `1.0.0.4-acc3.0.0.1-si4.2.0.3` |
| `wso2.deployment.ob.bi.imagePullPolicy`                    | Refer to [doc](https://kubernetes.io/docs/concepts/containers/images#updating-images) | `Always`                       |
| `wso2.deployment.ob.bi.livenessProbe.initialDelaySeconds`  | Initial delay for the live-ness probe for OBBI node                                   | 20                             |
| `wso2.deployment.ob.bi.livenessProbe.periodSeconds`        | Period of the live-ness probe for OBBI node                                           | 10                             |
| `wso2.deployment.ob.bi.readinessProbe.initialDelaySeconds` | Initial delay for the readiness probe for OBBI node                                   | 20                             |
| `wso2.deployment.ob.bi.readinessProbe.periodSeconds`       | Period of the readiness probe for OBBI node                                           | 10                             |
| `wso2.deployment.ob.bi.resources.requests.memory`          | The minimum amount of memory that should be allocated for a Pod                       | 4Gi                            |
| `wso2.deployment.ob.bi.resources.requests.cpu`             | The minimum amount of CPU that should be allocated for a Pod                          | 2000m                          |
| `wso2.deployment.ob.bi.resources.limits.memory`            | The maximum amount of memory that should be allocated for a Pod                       | 4Gi                            |
| `wso2.deployment.ob.bi.resources.limits.cpu`               | The maximum amount of CPU that should be allocated for a Pod                          | 2000m                          |
| `wso2.deployment.ob.bi.resources.jvm.heap.memory.xms`      | The initial memory allocation for JVM Heap                                            | 3048m                          |
| `wso2.deployment.ob.bi.resources.jvm.heap.memory.xmx`      | The maximum memory allocation for JVM Heap                                            | 3048m                          |

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

