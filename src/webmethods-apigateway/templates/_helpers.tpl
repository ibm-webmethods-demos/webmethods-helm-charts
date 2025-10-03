{{/*
Expand the name of the chart.
*/}}
{{- define "webmethods-apigateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webmethods-apigateway.fullname" -}}
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
{{- define "webmethods-apigateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webmethods-apigateway.labels" -}}
helm.sh/chart: {{ include "webmethods-apigateway.chart" . }}
{{ include "webmethods-apigateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "webmethods-apigateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "webmethods-apigateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "webmethods-apigateway.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "webmethods-apigateway.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Transform Simple Dictionary into ENV array
*/}}
{{- define "webmethods-apigateway.dictToEnvs" -}}
{{- range $key, $value := . }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}

{{/*
Transform Secrets Dictionary into ENV array
*/}}
{{- define "webmethods-apigateway.secretsDictToEnvs" -}}
{{- range $key, $value := . }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretKeyRef | quote }}
      key: {{ $value.key | quote }}
{{- end }}
{{- end }}

{{/*
the name of the gw ui service
*/}}
{{- define "webmethods-apigateway.gwuiFullname" -}}
{{- $uname := (include "webmethods-apigateway.fullname" .) }}
{{- printf "%s-%s" $uname "gwui" }}
{{- end }}

{{/*
the name of the gw runtime service
*/}}
{{- define "webmethods-apigateway.gwruntimeFullname" -}}
{{- $uname := (include "webmethods-apigateway.fullname" .) }}
{{- printf "%s-%s" $uname "gwruntime" }}
{{- end }}

{{/*
the name of the IS runtime service
*/}}
{{- define "webmethods-apigateway.isruntimeFullname" -}}
{{- $uname := (include "webmethods-apigateway.fullname" .) }}
{{- printf "%s-%s" $uname "isruntime" }}
{{- end }}


{{/*
the name of the gw-ui backend service for the ingress
*/}}
{{- define "webmethods-apigateway.ingressBackendServiceGwui" -}}
{{- $uname := (include "webmethods-apigateway.gwuiFullname" .) }}
{{- if .Values.ingress.gwui.backendSSL -}}
{{- printf "%s-%s" $uname "ssl" }}
{{- else }}
{{- printf "%s" $uname }}
{{- end }}
{{- end }}

{{/*
the gw-ui backend port for the ingress
*/}}
{{- define "webmethods-apigateway.ingressBackendPortGwui" -}}
{{- $port := .Values.service.gwui.port }}
{{- $portssl := .Values.service.gwuissl.port }}
{{- if .Values.ingress.gwui.backendSSL -}}
{{- printf "%s" $port }}
{{- else }}
{{- printf "%s" $portssl }}
{{- end }}
{{- end }}

{{/*
Is Clustering enabled
*/}}
{{- define "webmethods-apigateway.isClusteringEnabled" }}
  {{- $clusteringTypes := list "ignite" "terracotta" }}
  {{- if has (lower .) $clusteringTypes }}
    {{- true -}}
  {{- end }}
{{- end }}

{{/*
Is Clustering Ignite
*/}}
{{- define "webmethods-apigateway.isClusteringIgnite" }}
  {{- if eq (lower .) "ignite" }}
true
  {{- end }}
{{- end }}

{{/*
Is Clustering Terracotta
*/}}
{{- define "webmethods-apigateway.isClusteringTerracotta" }}
  {{- if eq (lower .) "terracotta" }}
true
  {{- end }}
{{- end }}