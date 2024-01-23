{{/*
# -------------------------------------------------------------------------------------
#
# Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained 
# herein is strictly forbidden, unless permitted by WSO2 in accordance with the 
# WSO2 Commercial License available at https://wso2.com/licenses/eula/3.2
#
# --------------------------------------------------------------------------------------s
*/}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "am-all-in-one.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "am-all-in-one.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "am-all-in-one.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "am-all-in-one.labels" -}}
app.kubernetes.io/name: {{ include "am-all-in-one.name" . }}
helm.sh/chart: {{ include "am-all-in-one.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Common prefix prepended to Kubernetes resources of this chart
*/}}
{{- define "am-all-in-one.resource.prefix" -}}
{{- "wso2am-all-in-one" }}
{{- end -}}

{{- define "image" }}
{{- $imageName := .deployment.imageName }}
{{- $imageTag := .deployment.imageTag | default "" }}
{{- if or (eq .Values.wso2.subscription.username "") (eq .Values.wso2.subscription.password "") -}}
{{- $dockerRegistry := .deployment.dockerRegistry | default "wso2" }}
image: {{ $dockerRegistry }}/{{ $imageName }}{{- if not (eq $imageTag "") }}{{- printf ":%s" $imageTag -}}{{- end }}
{{- else }}
{{- $dockerRegistry := .deployment.dockerRegistry | default "docker.wso2.com" }}
{{- $parts := len (split "." $imageTag) }}
{{- if eq $parts 3 }}
image: {{ $dockerRegistry }}/{{ $imageName }}{{- if not (eq $imageTag "") }}:{{ $imageTag }}.0{{- end }}
{{- else }}
image: {{ $dockerRegistry }}/{{ $imageName }}{{- if not (eq $imageTag "") }}:{{ $imageTag }}{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "ob-pattern-5.resource.prefix" -}}
{{- "wso2ob-pattern-5" }}
{{- end -}}