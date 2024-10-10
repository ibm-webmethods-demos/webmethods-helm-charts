{{/*
Expand the name of the chart.
*/}}
{{- define "webmethods-mft-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webmethods-mft-server.fullname" -}}
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
{{- define "webmethods-mft-server.fullname.headless" -}}
{{- printf "%s-%s" (include "webmethods-mft-server.fullname" .) "hl" | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "webmethods-mft-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webmethods-mft-server.labels" -}}
helm.sh/chart: {{ include "webmethods-mft-server.chart" . }}
{{ include "webmethods-mft-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "webmethods-mft-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "webmethods-mft-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "webmethods-mft-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "webmethods-mft-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Transform Simple Dictionary into ENV array
*/}}
{{- define "webmethods-mft-server.dictToEnvs" -}}
{{- range $key, $value := . }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}

{{/*
Transform Secrets Dictionary into ENV array
*/}}
{{- define "webmethods-mft-server.secretsDictToEnvs" -}}
{{- range $key, $value := . }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretKeyRef | quote }}
      key: {{ $value.key | quote }}
{{- end }}
{{- end }}

{{/*
the name of the ui service
*/}}
{{- define "webmethods-mft-server.adminUIFullname" -}}
{{- $uname := (include "webmethods-mft-server.fullname" .) }}
{{- printf "%s-%s" $uname "adminui" }}
{{- end }}

{{/*
the name of the runtime service
*/}}
{{- define "webmethods-mft-server.isRuntimeFullname" -}}
{{- $uname := (include "webmethods-mft-server.fullname" .) }}
{{- printf "%s-%s" $uname "isruntime" }}
{{- end }}

{{/*
the name of the http transfer ui service
*/}}
{{- define "webmethods-mft-server.httpTransferUIFullname" -}}
{{- $uname := (include "webmethods-mft-server.fullname" .) }}
{{- printf "%s-%s" $uname "httptransferui" }}
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
  {{ include "webmethods-mft-server.joinListWithSpaces" .Values.test }}
return: |
  foo bar
*/}}
{{- define "webmethods-mft-server.joinListWithSpaces" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}}{{ printf " " }}{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}