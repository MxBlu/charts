{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dspace.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dspace.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 24 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 24 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dspace.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Zookeeper image name
*/}}
{{- define "dspace.image" -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}

{{/*
Return the Postgres url from the config
*/}}
{{- define "dspace.pg-url" -}}
{{- $postgresService := .Values.postgresService -}}
{{- $postgresPort := (default 5432 .Values.postgresPort) | toString -}}
{{- printf "jdbc:postgresql:\\/\\/%s:%s\\/dspace" $postgresService $postgresPort -}}
{{- end -}}

{{/*
Return the Solr url from the config
*/}}
{{- define "dspace.solr-url" -}}
{{- $solrService := default "localhost" .Values.solrService -}}
{{- $solrPort := (default 8080 .Values.solrPort) | toString -}}
{{- printf "http:\\/\\/%s:%s\\/solr" $solrService $solrPort -}}
{{- end -}}