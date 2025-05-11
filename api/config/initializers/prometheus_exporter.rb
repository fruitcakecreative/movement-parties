require 'prometheus_exporter/middleware'
require 'prometheus_exporter/instrumentation'

PrometheusExporter::Instrumentation::Process.start(type: 'web')
PrometheusExporter::Instrumentation::ActiveRecord.start
