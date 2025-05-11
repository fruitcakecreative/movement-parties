require 'prometheus_exporter/instrumentation'

PrometheusExporter::Instrumentation::ActiveRecord.start
PrometheusExporter::Instrumentation::Process.start(type: 'web')
