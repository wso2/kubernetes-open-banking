# am-all-in-one

![Version: 4.2.0-1](https://img.shields.io/badge/Version-4.2.0--1-informational?style=flat-square) ![AppVersion: 4.2.0](https://img.shields.io/badge/AppVersion-4.2.0-informational?style=flat-square)

A Helm chart for the deployment of WSO2 API Manager Single Node.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws.efs.accessPoints | object | `{"carbonDb":"","solr":""}` | EFS Access Points for static provisioning |
| aws.efs.capacity | string | `""` | EFS capacity |
| aws.efs.directoryPerms | string | `"0777"` | EFS directory permissions |
| aws.efs.fileSystemId | string | `""` | EFS file system ID for mounting the persistent volume |
| aws.enabled | bool | `true` | If AWS is used as the cloud provider |
| aws.region | string | `""` | AWS region |
| aws.secretsManager.secretIdentifiers.internalKeystorePassword | object | `{"secretKey":"","secretName":""}` | Internal keystore password identifier in secrets manager |
| aws.secretsManager.secretIdentifiers.internalKeystorePassword.secretKey | string | `""` | AWS Secrets Manager secret key |
| aws.secretsManager.secretIdentifiers.internalKeystorePassword.secretName | string | `""` | AWS Secrets Manager secret name |
| aws.secretsManager.secretProviderClass | string | `"wso2am-am-secret-provider-class"` | AWS Secrets Manager secret provider class name |
| aws.serviceAccountName | string | `""` |  |
| azure.enabled | bool | `false` | If Azure is used as the cloud provider |
| azure.keyVault.activeDirectory.servicePrincipal | object | `{"appId":"","clientSecretName":"","credentialsSecretName":""}` | Service Principal created for transacting with the target Azure Key Vault For advanced details refer to official documentation (https://github.com/Azure/secrets-store-csi-driver-provider-azure/blob/master/docs/service-principal-mode.md) |
| azure.keyVault.activeDirectory.servicePrincipal.appId | string | `""` | Application ID of the service principal used in secret-store-csi |
| azure.keyVault.activeDirectory.servicePrincipal.clientSecretName | string | `""` | Client secret name of the service principal used in secret-store-csi |
| azure.keyVault.activeDirectory.servicePrincipal.credentialsSecretName | string | `""` | Credentials secret name of the service principal used as nodePublisherRef |
| azure.keyVault.activeDirectory.tenantId | string | `""` | Azure Active Directory tenant ID of the target Key Vault |
| azure.keyVault.name | string | `""` | Azure Key vault used for credential management |
| azure.keyVault.resourceManager.resourceGroup | string | `""` | Name of the Azure Resource Group to which the target Azure Key Vault belongs |
| azure.keyVault.resourceManager.subscriptionId | string | `""` | Subscription ID of the target Azure Key Vault |
| azure.keyVault.secretIdentifiers.internalKeystoreKeyPassword | string | `""` | Internal keystore key password identifier in keyvault |
| azure.keyVault.secretIdentifiers.internalKeystorePassword | string | `""` | Internal keystore password identifier in keyvault |
| azure.keyVault.secretProviderClass | string | `"wso2am-secret-provider-class"` | Azure Key vault secret provider class name |
| azure.persistence.capacity | string | `""` | Persistent volume capacity |
| azure.persistence.fileShare | string | `""` | Azure fileshare name |
| azure.persistence.secretName | string | `""` | Azure file secret name |
| azure.persistence.storageClass | string | `""` | Persistent volume storage class |
| azure.serviceAccount | string | `"wso2am-all-in-one-svc-account"` |  |
| gcp.enabled | bool | `true` | If GCP is used as the cloud provider |
| gcp.fs | object | `{"capacity":"","fileshares":{"carbonDB":{"fileShareName":"","fileStoreName":"","ip":""},"solr":{"fileShareName":"","fileStoreName":"","ip":""}},"location":"","network":"","tier":""}` | File Store configuration parameters |
| gcp.fs.capacity | string | `""` | Storage capacity of the file system (in GB or other appropriate units) |
| gcp.fs.fileshares | object | `{"carbonDB":{"fileShareName":"","fileStoreName":"","ip":""},"solr":{"fileShareName":"","fileStoreName":"","ip":""}}` | FileStore configuration for specific services |
| gcp.fs.fileshares.carbonDB | object | `{"fileShareName":"","fileStoreName":"","ip":""}` | FileShare configs for CarbonDB persistent storage |
| gcp.fs.fileshares.carbonDB.fileShareName | string | `""` | FileShare of the CarbonDB persistent storage |
| gcp.fs.fileshares.carbonDB.fileStoreName | string | `""` | FileStore of the CarbonDB persistent storage |
| gcp.fs.fileshares.carbonDB.ip | string | `""` | IP of the CarbonDB persistent storage |
| gcp.fs.fileshares.solr | object | `{"fileShareName":"","fileStoreName":"","ip":""}` | FileShare configs for Solr persistent storage |
| gcp.fs.fileshares.solr.fileShareName | string | `""` | FileShare of the Solr persistent storage |
| gcp.fs.fileshares.solr.fileStoreName | string | `""` | FileStore of the Solr persistent storage |
| gcp.fs.fileshares.solr.ip | string | `""` | IP of the Solr persistent storage |
| gcp.fs.location | string | `""` | Region of the FileStore |
| gcp.fs.network | string | `""` | Network of the FileStore |
| gcp.fs.tier | string | `""` | Tier of the FileStore |
| gcp.secretsManager | object | `{"projectId":"","secret":{"secretName":"","secretVersion":""},"secretProviderClass":""}` | Secrets Manager configuration parameters |
| gcp.secretsManager.projectId | string | `""` | Project ID |
| gcp.secretsManager.secret.secretName | string | `""` | Name of the secret |
| gcp.secretsManager.secret.secretVersion | string | `""` | Version of the secret  |
| gcp.secretsManager.secretProviderClass | string | `""` | Secret provider class |
| gcp.serviceAccountName | string | `""` | Service Account with access to read secrets |
| kubernetes.ingress.gateway.annotations | object | `{"nginx.ingress.kubernetes.io/backend-protocol":"HTTPS","nginx.ingress.kubernetes.io/proxy-buffer-size":"8k","nginx.ingress.kubernetes.io/proxy-buffering":"on"}` | Ingress annotations for Gateway pass-through |
| kubernetes.ingress.gateway.enabled | bool | `true` |  |
| kubernetes.ingress.gateway.hostname | string | `"gw.wso2.com"` | Ingress hostname for Gateway pass-through |
| kubernetes.ingress.management.annotations."nginx.ingress.kubernetes.io/affinity" | string | `"cookie"` |  |
| kubernetes.ingress.management.annotations."nginx.ingress.kubernetes.io/backend-protocol" | string | `"HTTPS"` |  |
| kubernetes.ingress.management.annotations."nginx.ingress.kubernetes.io/session-cookie-hash" | string | `"sha1"` |  |
| kubernetes.ingress.management.annotations."nginx.ingress.kubernetes.io/session-cookie-name" | string | `"route"` |  |
| kubernetes.ingress.management.enabled | bool | `true` |  |
| kubernetes.ingress.management.hostname | string | `"am.wso2.com"` |  |
| kubernetes.ingress.ratelimit.burstLimit | string | `""` | Ingress ratelimit burst limit |
| kubernetes.ingress.ratelimit.enabled | bool | `false` | Ingress rate limit |
| kubernetes.ingress.ratelimit.zoneName | string | `""` | Ingress ratelimit zone name |
| kubernetes.ingress.tlsSecret | string | `""` | Kubernetes secret created for Ingress TLS |
| kubernetes.ingress.websocket.annotations | string | `nil` | Ingress annotations for Websocket |
| kubernetes.ingress.websocket.enabled | bool | `true` |  |
| kubernetes.ingress.websocket.hostname | string | `"websocket.wso2.com"` | Ingress hostname for Websocket |
| kubernetes.ingress.websub.annotations | string | `nil` | Ingress annotations for Websub |
| kubernetes.ingress.websub.enabled | bool | `true` |  |
| kubernetes.ingress.websub.hostname | string | `"websub.wso2.com"` | Ingress hostname for Websub |
| kubernetes.ingressClass | string | `"nginx"` | Ingress class to be used for the ingress resource |
| kubernetes.securityContext.runAsGroup | int | `802` |  |
| kubernetes.securityContext.runAsUser | int | `802` | User ID of the container |
| wso2.apim.configurations.adminPassword | string | `"admin"` | Super admin password |
| wso2.apim.configurations.adminUsername | string | `"admin"` | Super admin username |
| wso2.apim.configurations.cache.gateway_token.enabled | bool | `true` | Gateway token cache enabled |
| wso2.apim.configurations.cache.gateway_token.expiryTime | string | `"15m"` | Gateway token cache expiration time |
| wso2.apim.configurations.cache.jwt_claim.enabled | bool | `true` | Gateway JWT claim cache enabled |
| wso2.apim.configurations.cache.jwt_claim.expiryTime | string | `"15m"` | Gateway JWT claim cache expiration time |
| wso2.apim.configurations.cache.km_token.enabled | bool | `true` | Gateway KM token cache enabled |
| wso2.apim.configurations.cache.km_token.expiryTime | string | `"15m"` | Gateway KM token cache expiration time |
| wso2.apim.configurations.cache.publisher_roles.enabled | bool | `false` |  |
| wso2.apim.configurations.cache.recent_apis.enabled | bool | `false` | Gateway recent APIs cache enabled |
| wso2.apim.configurations.cache.resource.enabled | bool | `true` | Gateway resource cache enabled |
| wso2.apim.configurations.cache.resource.expiryTime | string | `"900s"` | Gateway resource cache expiration time |
| wso2.apim.configurations.cache.scopes.enabled | bool | `false` |  |
| wso2.apim.configurations.cache.tags.enabled | bool | `true` | Gateway tags cache enabled |
| wso2.apim.configurations.cache.tags.expiryTime | string | `"2m"` |  |
| wso2.apim.configurations.cors.allowCredentials | bool | `false` | CORS Access-Control-Allow-Credentials |
| wso2.apim.configurations.cors.allowHeaders | list | `["authorization","Access-Control-Allow-Origin","Content-Type","SOAPAction","apikey","Internal-Key"]` | CORS Access-Control-Allow-Headers |
| wso2.apim.configurations.cors.allowMethods | list | `["GET","PUT","POST","DELETE","PATCH","OPTIONS"]` | CORS Access-Control-Allow-Methods |
| wso2.apim.configurations.cors.allowOrigins | list | `["*"]` | CORS Access-Control-Allow-Origin |
| wso2.apim.configurations.cors.enableForWS | bool | `false` | Enable CORS for Websockets |
| wso2.apim.configurations.cors.enabled | bool | `true` | CORS configuration enabled |
| wso2.apim.configurations.databases.apim_db | object | `{"password":"","poolParameters":{"defaultAutoCommit":false,"maxActive":100,"maxWait":60000,"minIdle":5,"testOnBorrow":true,"testWhileIdle":true,"validationInterval":30000},"url":"","username":""}` | APIM APIMDB configurations. This is required for gateway only in a multi-tenancy scenario |
| wso2.apim.configurations.databases.apim_db.password | string | `""` | APIM APIMDB password |
| wso2.apim.configurations.databases.apim_db.poolParameters | object | `{"defaultAutoCommit":false,"maxActive":100,"maxWait":60000,"minIdle":5,"testOnBorrow":true,"testWhileIdle":true,"validationInterval":30000}` | APIM database JDBC pool parameters |
| wso2.apim.configurations.databases.apim_db.url | string | `""` | APIM APIMDB URL |
| wso2.apim.configurations.databases.apim_db.username | string | `""` | APIM APIMDB username |
| wso2.apim.configurations.databases.jdbc.driver | string | `""` | JDBC driver class name |
| wso2.apim.configurations.databases.shared_db.password | string | `""` | APIM SharedDB password |
| wso2.apim.configurations.databases.shared_db.poolParameters | object | `{"defaultAutoCommit":false,"maxActive":100,"maxWait":60000,"minIdle":5,"testOnBorrow":true,"testWhileIdle":true,"validationInterval":30000}` | APIM database JDBC pool parameters |
| wso2.apim.configurations.databases.shared_db.url | string | `""` | APIM SharedDB URL |
| wso2.apim.configurations.databases.shared_db.username | string | `""` | APIM SharedDB username |
| wso2.apim.configurations.databases.type | string | `""` | Database type. eg: mysql, oracle, mssql, postgres |
| wso2.apim.configurations.devportal.applicationSharingImpl | string | `nil` |  |
| wso2.apim.configurations.devportal.applicationSharingType | string | `nil` |  |
| wso2.apim.configurations.devportal.create_default_application | string | `nil` | Whether to create default application |
| wso2.apim.configurations.devportal.defaultReservedUsername | string | `nil` |  |
| wso2.apim.configurations.devportal.displayDeprecatedApis | string | `nil` | Whether to display deprecated APIs |
| wso2.apim.configurations.devportal.displayMultipleVersions | string | `nil` | Whether to display multiple versions of same API or only showing the latest version of an API |
| wso2.apim.configurations.devportal.enableAnonymousMode | string | `nil` | Whether anonymous mode is enabled |
| wso2.apim.configurations.devportal.enableApplicationSharing | string | `nil` |  |
| wso2.apim.configurations.devportal.enableComments | string | `nil` | Whether to display comments for API |
| wso2.apim.configurations.devportal.enableCrossTenantSubscriptions | string | `nil` |  |
| wso2.apim.configurations.devportal.enableForum | string | `nil` | Whether to display forum for API |
| wso2.apim.configurations.devportal.enableKeyProvisioning | string | `nil` |  |
| wso2.apim.configurations.devportal.enableRatings | string | `nil` | Whether to display ratings for API |
| wso2.apim.configurations.devportal.loginUsernameCaseInsensitive | string | `nil` |  |
| wso2.apim.configurations.eventHandlers[0].name | string | `"userPostSelfRegistration"` |  |
| wso2.apim.configurations.eventHandlers[0].subscriptions[0] | string | `"POST_ADD_USER"` |  |
| wso2.apim.configurations.eventListeners[0].id | string | `"token_revocation"` |  |
| wso2.apim.configurations.eventListeners[0].name | string | `"org.wso2.is.notification.ApimOauthEventInterceptor"` |  |
| wso2.apim.configurations.eventListeners[0].order | int | `1` |  |
| wso2.apim.configurations.eventListeners[0].properties.notificationEndpoint | string | `"https://localhost:${mgt.transport.https.port}/internal/data/v1/notify"` |  |
| wso2.apim.configurations.eventListeners[0].type | string | `"org.wso2.carbon.identity.core.handler.AbstractIdentityHandler"` |  |
| wso2.apim.configurations.gateway.environments | list | `[{"description":"This is a hybrid gateway that handles both production and sandbox token traffic.","displayInApiConsole":true,"httpHostname":"gw.wso2.com","name":"Default","provider":"wso2","serviceName":"wso2am-gateway-service","servicePort":9443,"showAsTokenEndpointUrl":true,"type":"hybrid","websubHostname":"websub.wso2.com","wsHostname":"websocket.wso2.com"}]` | APIM Gateway environments |
| wso2.apim.configurations.iskm.enabled | bool | `false` |  |
| wso2.apim.configurations.iskm.revokeURL | string | `""` |  |
| wso2.apim.configurations.iskm.serviceName | string | `""` |  |
| wso2.apim.configurations.jwt.claimDialect | string | `"http://wso2.org/claims"` |  |
| wso2.apim.configurations.jwt.claimsExtractorImpl | string | `"org.wso2.carbon.apimgt.impl.token.DefaultClaimsRetriever"` |  |
| wso2.apim.configurations.jwt.enableUserClaims | string | `"false"` |  |
| wso2.apim.configurations.jwt.enabled | bool | `false` |  |
| wso2.apim.configurations.jwt.encoding | string | `"base64"` |  |
| wso2.apim.configurations.jwt.generatorImpl | string | `"org.wso2.carbon.apimgt.keymgt.token.JWTGenerator"` |  |
| wso2.apim.configurations.jwt.header | string | `"X-JWT-Assertion"` |  |
| wso2.apim.configurations.jwt.signingAlgorithm | string | `"SHA256withRSA"` |  |
| wso2.apim.configurations.notification.enableAuthentication | bool | `false` |  |
| wso2.apim.configurations.notification.enableStartTls | bool | `false` |  |
| wso2.apim.configurations.notification.fromAddress | string | `nil` |  |
| wso2.apim.configurations.notification.hostname | string | `nil` |  |
| wso2.apim.configurations.notification.password | string | `nil` |  |
| wso2.apim.configurations.notification.port | int | `25` |  |
| wso2.apim.configurations.notification.signature | string | `nil` |  |
| wso2.apim.configurations.notification.username | string | `nil` |  |
| wso2.apim.configurations.oauth_config.authHeader | string | `"Authorization"` | OAuth authorization header name |
| wso2.apim.configurations.oauth_config.enableTokenEncryption | bool | `false` | Enable token encryption |
| wso2.apim.configurations.oauth_config.enableTokenHashing | bool | `false` | Enable token hashing |
| wso2.apim.configurations.oauth_config.removeOutboundAuthHeader | bool | `true` | Remove auth header from outgoing requests |
| wso2.apim.configurations.oauth_config.revokeEndpoint | string | `""` | OAuth revoke endpoint |
| wso2.apim.configurations.publisher.supportedDocumentTypes | string | `""` | Supported document types in Publisher.  This should be used only if there are additional document types to be supported. |
| wso2.apim.configurations.security.jksSecretName | string | `""` | Kubernetes secret containing the keystores and truststore |
| wso2.apim.configurations.security.keystores.internal.alias | string | `"wso2carbon"` | Internal keystore alias |
| wso2.apim.configurations.security.keystores.internal.enabled | bool | `false` | Internal keystore enabled |
| wso2.apim.configurations.security.keystores.internal.keyPassword | string | `""` | Internal keystore key password |
| wso2.apim.configurations.security.keystores.internal.name | string | `"wso2carbon.jks"` | Internal keystore name |
| wso2.apim.configurations.security.keystores.internal.password | string | `""` | Internal keystore password |
| wso2.apim.configurations.security.keystores.primary.alias | string | `"wso2carbon"` | Primary keystore alias |
| wso2.apim.configurations.security.keystores.primary.enabled | bool | `false` | Primary keystore enabled |
| wso2.apim.configurations.security.keystores.primary.keyPassword | string | `""` | Primary keystore key password |
| wso2.apim.configurations.security.keystores.primary.name | string | `"wso2carbon.jks"` | Primary keystore name |
| wso2.apim.configurations.security.keystores.primary.password | string | `""` | Primary keystore password |
| wso2.apim.configurations.security.keystores.tls.alias | string | `"wso2carbon"` | TLS keystore alias |
| wso2.apim.configurations.security.keystores.tls.enabled | bool | `true` | TLS keystore enabled |
| wso2.apim.configurations.security.keystores.tls.keyPassword | string | `"wso2carbon"` | TLS keystore key password |
| wso2.apim.configurations.security.keystores.tls.name | string | `"wso2carbon.jks"` | TLS keystore name |
| wso2.apim.configurations.security.keystores.tls.password | string | `"wso2carbon"` | TLS keystore password |
| wso2.apim.configurations.security.truststore.name | string | `"client-truststore.jks"` | Truststore name |
| wso2.apim.configurations.security.truststore.password | string | `""` | Truststore password |
| wso2.apim.configurations.serviceProvider.spNameRegex | string | `"^[\\sa-zA-Z0-9._-]*$"` |  |
| wso2.apim.configurations.syncRuntimeArtifacts.gateway.labels | list | `["Default"]` | Gateway label used to filter out artifact retrieval |
| wso2.apim.configurations.throttling.blacklistCondition.period | string | `nil` |  |
| wso2.apim.configurations.throttling.blacklistCondition.startDelay | string | `nil` |  |
| wso2.apim.configurations.throttling.enableBlacklistCondition | bool | `true` |  |
| wso2.apim.configurations.throttling.enableDataPublishing | bool | `true` |  |
| wso2.apim.configurations.throttling.enableHeaderBasedThrottling | bool | `false` |  |
| wso2.apim.configurations.throttling.enableJwtClaimBasedThrottling | bool | `false` |  |
| wso2.apim.configurations.throttling.enablePersistence | bool | `true` |  |
| wso2.apim.configurations.throttling.enablePolicyDeploy | bool | `true` |  |
| wso2.apim.configurations.throttling.enableQueryParamBasedThrottling | bool | `false` |  |
| wso2.apim.configurations.throttling.enableUnlimitedTier | bool | `true` |  |
| wso2.apim.configurations.throttling.eventManagement.hostname | string | `nil` |  |
| wso2.apim.configurations.throttling.eventManagement.port | string | `nil` |  |
| wso2.apim.configurations.throttling.eventSync.hostname | string | `nil` |  |
| wso2.apim.configurations.throttling.eventSync.port | string | `nil` |  |
| wso2.apim.configurations.throttling.jms.startDelay | string | `nil` |  |
| wso2.apim.configurations.throttling.throttleDecisionEndpoints | list | `[]` |  |
| wso2.apim.configurations.token.revocation.EnablePersistentNotifier | bool | `true` |  |
| wso2.apim.configurations.token.revocation.EnableRealtimeNotifier | bool | `true` |  |
| wso2.apim.configurations.token.revocation.NotifierImpl | string | `"org.wso2.carbon.apimgt.keymgt.events.TokenRevocationNotifierImpl"` |  |
| wso2.apim.configurations.token.revocation.PersistentNotifierHostname | string | `"https://localhost:2379/v2/keys/jti/"` |  |
| wso2.apim.configurations.token.revocation.PersistentNotifierPassword | string | `"root"` |  |
| wso2.apim.configurations.token.revocation.PersistentNotifierTtl | int | `5000` |  |
| wso2.apim.configurations.token.revocation.PersistentNotifierUsername | string | `"root"` |  |
| wso2.apim.configurations.token.revocation.RealtimeNotifierTtl | int | `5000` |  |
| wso2.apim.configurations.transport.receiver.ciphers[0] | string | `"SSL_RSA_WITH_RC4_128_MD5"` |  |
| wso2.apim.configurations.transport.receiver.ciphers[1] | string | `"SSL_RSA_WITH_RC4_128_SHA"` |  |
| wso2.apim.configurations.transport.receiver.keystore.fileName | string | `"$ref{keystore.tls.file_name}"` |  |
| wso2.apim.configurations.transport.receiver.keystore.password | string | `"$ref{keystore.tls.password}"` |  |
| wso2.apim.configurations.transport.receiver.sessionTimeout | string | `""` |  |
| wso2.apim.configurations.transport.receiver.sslEnabledProtocols[0] | string | `"TLSv1"` |  |
| wso2.apim.configurations.transport.receiver.sslEnabledProtocols[1] | string | `"TLSv1.1"` |  |
| wso2.apim.configurations.transport.receiver.sslEnabledProtocols[2] | string | `"TLSv1.2"` |  |
| wso2.apim.configurations.transport.receiver.sslPort | int | `9711` |  |
| wso2.apim.configurations.transport.receiver.sslReceiverThreadPoolSize | int | `100` |  |
| wso2.apim.configurations.transport.receiver.tcpPort | int | `9611` |  |
| wso2.apim.configurations.transport.receiver.tcpReceiverThreadPoolSize | int | `100` |  |
| wso2.apim.configurations.transport.receiver.type | string | `""` |  |
| wso2.apim.configurations.transport.receiver.workerThreads | int | `10` |  |
| wso2.apim.configurations.userStore.properties | string | `nil` | User store properties |
| wso2.apim.configurations.userStore.type | string | `"database_unique_id"` | User store type.  https://apim.docs.wso2.com/en/latest/administer/managing-users-and-roles/managing-user-stores/configure-primary-user-store/configuring-the-primary-user-store/ |
| wso2.apim.configurations.workflow.callbackEndpoint | string | `""` |  |
| wso2.apim.configurations.workflow.clientRegistrationEndpoint | string | `""` |  |
| wso2.apim.configurations.workflow.enable | bool | `false` |  |
| wso2.apim.configurations.workflow.serviceUrl | string | `""` |  |
| wso2.apim.configurations.workflow.tokenEndpoint | string | `""` |  |
| wso2.apim.log4j2.loggers | string | `""` | Console loggers that can be enabled. Allowed values are AUDIT_LOG_CONSOLE, HTTP_ACCESS_CONSOLE, TRANSACTION_CONSOLE, CORRELATION_CONSOLE |
| wso2.apim.secureVaultEnabled | bool | `false` | Secure vauld enabled |
| wso2.apim.version | string | `"4.2.0"` | APIM version |
| wso2.choreoAnalytics | object | `{"enabled":false,"endpoint":"","onpremKey":""}` | WSO2 Choreo Analytics Parameters If provided, these parameters will be used publish analytics data to Choreo Analytics environment (https://apim.docs.wso2.com/en/latest/observe/api-manager-analytics/configure-analytics/register-for-analytics/). |
| wso2.choreoAnalytics.endpoint | string | `""` | Choreo Analytics cloud service endpoint |
| wso2.choreoAnalytics.onpremKey | string | `""` | On-premise key for Choreo Analytics |
| wso2.deployment.image.digest | string | `""` | Docker image digest |
| wso2.deployment.image.imagePullPolicy | string | `"Always"` | Refer to the Kubernetes documentation on updating images (https://kubernetes.io/docs/concepts/containers/images/#updating-images) |
| wso2.deployment.image.registry | string | `""` | Registry containing the image |
| wso2.deployment.image.repository | string | `""` | Repository name consisting the image |
| wso2.deployment.lifecycle.preStopHook.sleepSeconds | int | `10` | Time to wait until the apim is terminated gracefully |
| wso2.deployment.livenessProbe.failureThreshold | int | `3` | Minimum consecutive successes for the probe to be considered successful after having failed |
| wso2.deployment.livenessProbe.initialDelaySeconds | int | `60` | Number of seconds after the container has started before liveness probes are initiated |
| wso2.deployment.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe |
| wso2.deployment.minAvailable | string | `"50%"` | Minimum available pod counts for PDB |
| wso2.deployment.persistence.solrIndexing | object | `{"capacity":{"carbonDatabase":"50M","solrIndexedData":"50M"},"enabled":false}` | Persistent runtime artifacts for Apache Solr-based indexing |
| wso2.deployment.persistence.solrIndexing.capacity.carbonDatabase | string | `"50M"` | For persisting the H2 based local Carbon database file |
| wso2.deployment.persistence.solrIndexing.capacity.solrIndexedData | string | `"50M"` | For persisting the indexed solr data |
| wso2.deployment.persistence.solrIndexing.enabled | bool | `false` | Indicates if persistence of the runtime artifacts for Apache Solr-based indexing is enabled By default, this is disabled |
| wso2.deployment.readinessProbe.failureThreshold | int | `5` | Minimum consecutive successes for the probe to be considered successful after having failed |
| wso2.deployment.readinessProbe.initialDelaySeconds | int | `60` | Number of seconds after the container has started before readiness probes are initiated |
| wso2.deployment.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe |
| wso2.deployment.resources.jvm.memory.xms | string | `"2048m"` | JVM heap memory Xms |
| wso2.deployment.resources.jvm.memory.xmx | string | `"2048m"` | JVM heap memory Xmx |
| wso2.deployment.resources.limits.cpu | string | `"2000m"` | CPU limit for API Manager |
| wso2.deployment.resources.limits.memory | string | `"2Gi"` | Memory limit for API Manager |
| wso2.deployment.resources.requests.cpu | string | `"1000m"` | CPU request for API Manager |
| wso2.deployment.resources.requests.memory | string | `"1Gi"` | Memory request for API Manager |
| wso2.deployment.startupProbe.failureThreshold | int | `3` | Minimum consecutive successes for the probe to be considered successful after having failed |
| wso2.deployment.startupProbe.initialDelaySeconds | int | `60` | Number of seconds after the container has started before startup probes are initiated |
| wso2.deployment.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.2](https://github.com/norwoodj/helm-docs/releases/v1.11.2)
