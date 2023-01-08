output "this_dashboard_url" {
  value = "https://app.datadoghq.com${datadog_dashboard_json.dashboard_json.url}"
}
