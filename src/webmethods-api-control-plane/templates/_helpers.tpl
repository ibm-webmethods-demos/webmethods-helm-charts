{{/*
Expand the name of the chart.
*/}}
{{- define "webmethods-api-control-plane.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webmethods-api-control-plane.fullname" -}}
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
{{- define "webmethods-api-control-plane.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webmethods-api-control-plane.labels" -}}
helm.sh/chart: {{ include "webmethods-api-control-plane.chart" . }}
{{ include "webmethods-api-control-plane.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "webmethods-api-control-plane.selectorLabels" -}}
app.kubernetes.io/name: {{ include "webmethods-api-control-plane.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "webmethods-api-control-plane.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "webmethods-api-control-plane.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Service names
*/}}
{{- define "webmethods-api-control-plane.name-assetcatalog" -}}
{{- printf "%s-%s" (include "webmethods-api-control-plane.fullname" .) .Values.applications.assetcatalog.name }}
{{- end }}

{{- define "webmethods-api-control-plane.name-elastic" -}}
{{- printf "%s-%s" (include "webmethods-api-control-plane.fullname" .) .Values.applications.es.name }}
{{- end }}

{{- define "webmethods-api-control-plane.name-engine" -}}
{{- printf "%s-%s" (include "webmethods-api-control-plane.fullname" .) .Values.applications.engine.name }}
{{- end }}

{{- define "webmethods-api-control-plane.name-ingress" -}}
{{- printf "%s-%s" (include "webmethods-api-control-plane.fullname" .) .Values.applications.ingress.name }}
{{- end }}

{{- define "webmethods-api-control-plane.name-ui" -}}
{{- printf "%s-%s" (include "webmethods-api-control-plane.fullname" .) .Values.applications.ui.name }}
{{- end }}

{{- define "webmethods-api-control-plane.name-jaegertracing" -}}
{{- printf "%s-%s" (include "webmethods-api-control-plane.fullname" .) .Values.applications.jaegertracing.name }}
{{- end }}