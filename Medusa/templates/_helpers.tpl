{{/*
Expand the name of the chart.
*/}}
{{- define "medusa.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "medusa.fullname" -}}
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
{{- define "medusa.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "medusa.labels" -}}
helm.sh/chart: {{ include "medusa.chart" . }}
{{ include "medusa.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "medusa.selectorLabels" -}}
app.kubernetes.io/name: {{ include "medusa.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "medusa.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "medusa.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
PostgreSQL hostname
*/}}
{{- define "medusa.postgresql.host" -}}
{{- if .Values.postgresql.enabled }}
{{- printf "%s-postgresql" (include "medusa.fullname" .) }}
{{- else }}
{{- required "PostgreSQL host is required when postgresql.enabled is false" .Values.medusa.databaseHost }}
{{- end }}
{{- end }}

{{/*
Redis hostname
*/}}
{{- define "medusa.redis.host" -}}
{{- if .Values.redis.enabled }}
{{- printf "%s-redis-master" (include "medusa.fullname" .) }}
{{- else }}
{{- required "Redis host is required when redis.enabled is false" .Values.medusa.redisHost }}
{{- end }}
{{- end }}

{{/*
Database URL
*/}}
{{- define "medusa.databaseUrl" -}}
{{- if .Values.medusa.databaseUrl }}
{{- .Values.medusa.databaseUrl }}
{{- else }}
{{- $host := include "medusa.postgresql.host" . }}
{{- $user := .Values.postgresql.auth.username }}
{{- $pass := .Values.postgresql.auth.password }}
{{- $db := .Values.postgresql.auth.database }}
{{- printf "postgres://%s:%s@%s:5432/%s" $user $pass $host $db }}
{{- end }}
{{- end }}

{{/*
Redis URL
*/}}
{{- define "medusa.redisUrl" -}}
{{- if .Values.medusa.redisUrl }}
{{- .Values.medusa.redisUrl }}
{{- else }}
{{- $host := include "medusa.redis.host" . }}
{{- printf "redis://%s:6379" $host }}
{{- end }}
{{- end }}