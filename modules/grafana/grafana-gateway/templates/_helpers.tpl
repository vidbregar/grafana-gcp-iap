{{/*
Expand the name of the chart.
*/}}
{{- define "grafana-gateway.name" -}}
{{- if .Values.nameOverride }}
{{- .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "grafana-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "grafana-gateway.labels" -}}
helm.sh/chart: {{ include "grafana-gateway.chart" . }}
{{ include "grafana-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "grafana-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "grafana-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
