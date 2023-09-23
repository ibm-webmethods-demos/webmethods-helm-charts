{{/*
Expand the name of the chart.
*/}}
{{- define "webmethods-devportal.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webmethods-devportal.fullname" -}}
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
{{- define "webmethods-devportal.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webmethods-devportal.labels" -}}
helm.sh/chart: {{ include "webmethods-devportal.chart" . }}
{{ include "webmethods-devportal.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "webmethods-devportal.selectorLabels" -}}
app.kubernetes.io/name: {{ include "webmethods-devportal.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "webmethods-devportal.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "webmethods-devportal.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
the name with headless suffix
*/}}
{{- define "webmethods-devportal.fullname.headless" -}}
{{- printf "%s-%s" (include "webmethods-devportal.fullname" .) "hl" | trimSuffix "-" }}
{{- end }}

{{/*
the list of endpoints for ignite cluster nodes
*/}}
{{- define "webmethods-devportal.dpo_endpoints_envs" -}}
{{- $replicas := int (toString (.Values.replicaCount)) }}
{{- if gt $replicas 3 }}
{{- $replicas = 3 }}
{{- end }}
{{- if .Values.settings.clustering.enabled }}
- name: PORTAL_SERVER_CACHE_DISTRIBUTED_ENABLED
  value: "true"
{{- end }}
{{- $podname := (include "webmethods-devportal.fullname" .) }}
{{- $svcname := (include "webmethods-devportal.fullname.headless" .) }}
  {{- range $i, $e := untilStep 0 $replicas 1 }}
- name: "PORTAL_SERVER_CACHE_DISTRIBUTED_CLUSTER_PEERS_{{ $i }}"
  value: "{{ $podname }}-{{ $i }}.{{ $svcname }}:47500..47509"
  {{- end }}
{{- end }}

{{/*
Transform Simple Dictionary into ENV array
*/}}
{{- define "webmethods-devportal.dictToEnvs" -}}
{{- range $key, $value := . }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}

{{/*
Transform Secrets Dictionary into ENV array
*/}}
{{- define "webmethods-devportal.secretsDictToEnvs" -}}
{{- range $key, $value := . }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretKeyRef | quote }}
      key: {{ $value.key | quote }}
{{- end }}
{{- end }}

{{/*
Adapted from Ref: https://github.com/openstack/openstack-helm-infra/blob/master/helm-toolkit/templates/utils/_joinListWithComma.tpl
abstract: |
  Joins a list of values into a space separated string
values: |
  test:
    - foo
    - bar
usage: |
  {{ include "webmethods-devportal.joinListWithSpaces" .Values.test }}
return: |
  foo bar
*/}}
{{- define "webmethods-devportal.joinListWithSpaces" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}}{{ printf " " }}{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}