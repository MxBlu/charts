{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "solr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "solr.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Define the name of the headless service for solr
*/}}
{{- define "solr.headless-service-name" -}}
{{- printf "%s-%s" (include "solr.fullname" .) "headless" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the client service for solr
*/}}
{{- define "solr.service-name" -}}
{{- printf "%s-%s" (include "solr.fullname" .) "svc" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The name of the zookeeper service
*/}}
{{- define "solr.zookeeper-name" -}}
{{- printf "%s-%s" .Values.zookeeper.serviceName "zookeeper" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The name of the zookeeper headless service
*/}}
{{- define "solr.zookeeper-service-name" -}}
{{ printf "%s-%s" (include "solr.zookeeper-name" .) "headless" | trunc 63 | trimSuffix "-"  }}
{{- end -}}

{{/*
The node list for zookeeper
*/}}
{{- define "solr.zookeeper-nodes" -}}
{{- $nodes := list -}}
{{- $zk_name := include "solr.zookeeper-name" . -}}
{{- $zk_service := include "solr.zookeeper-service-name" . -}}
{{- range $i, $e := until (int .Values.zookeeper.replicaCount) -}}
  {{- $nodes = printf "%s-%s.%s:2181" $zk_name (toString $i) $zk_service | append $nodes -}}
{{- end -}}
{{- join "," $nodes -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "solr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Define the name of the solr PVC
*/}}
{{- define "solr.pvc-name" -}}
{{ printf "%s-%s" (include "solr.fullname" .) "pvc" | trunc 63 | trimSuffix "-"  }}
{{- end -}}

{{/*
  Define the name of the solr.xml configmap
*/}}
{{- define "solr.configmap-name" -}}
{{- printf "%s-%s" (include "solr.fullname" .) "config-map" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Define the labels that should be applied to all resources in the chart
*/}}
{{- define "solr.common.labels" -}}
app: {{ template "solr.name" . }}
chart: {{ template "solr.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}
