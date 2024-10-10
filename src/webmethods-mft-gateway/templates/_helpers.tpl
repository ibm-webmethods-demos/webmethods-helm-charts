{{/*
Expand the name of the chart.
*/}}
{{- define "webmethods-mft-gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webmethods-mft-gateway.fullname" -}}
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
the name with headless suffix
*/}}
{{- define "webmethods-mft-gateway.fullname.headless" -}}
{{- printf "%s-%s" (include "webmethods-mft-gateway.fullname" .) "hl" | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "webmethods-mft-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webmethods-mft-gateway.labels" -}}
helm.sh/chart: {{ include "webmethods-mft-gateway.chart" . }}
{{ include "webmethods-mft-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "webmethods-mft-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "webmethods-mft-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "webmethods-mft-gateway.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "webmethods-mft-gateway.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Transform Simple Dictionary into ENV array
*/}}
{{- define "webmethods-mft-gateway.dictToEnvs" -}}
{{- range $key, $value := . }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}

{{/*
Transform Secrets Dictionary into ENV array
*/}}
{{- define "webmethods-mft-gateway.secretsDictToEnvs" -}}
{{- range $key, $value := . }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretKeyRef | quote }}
      key: {{ $value.key | quote }}
{{- end }}
{{- end }}

{{/*
the name of the registration port service
*/}}
{{- define "webmethods-mft-gateway.registrationPortFullname" -}}
{{- $uname := (include "webmethods-mft-gateway.fullname" .) }}
{{- printf "%s-%s" $uname "regport" }}
{{- end }}

{{/*
the name of the runtime service
*/}}
{{- define "webmethods-mft-gateway.isRuntimeFullname" -}}
{{- $uname := (include "webmethods-mft-gateway.fullname" .) }}
{{- printf "%s-%s" $uname "isruntime" }}
{{- end }}

{{/*
the name of the http transfer ui service
*/}}
{{- define "webmethods-mft-gateway.httpTransferFullname" -}}
{{- $uname := (include "webmethods-mft-gateway.fullname" .) }}
{{- printf "%s-%s" $uname "httptransfer" }}
{{- end }}

{{/*
the name of the TCP transfer service
*/}}
{{- define "webmethods-mft-gateway.tcpTransferFullname" -}}
{{- $uname := (include "webmethods-mft-gateway.fullname" .) }}
{{- printf "%s-%s" $uname "tcptransfer" }}
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
  {{ include "webmethods-mft-gateway.joinListWithSpaces" .Values.test }}
return: |
  foo bar
*/}}
{{- define "webmethods-mft-gateway.joinListWithSpaces" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}}{{ printf " " }}{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}