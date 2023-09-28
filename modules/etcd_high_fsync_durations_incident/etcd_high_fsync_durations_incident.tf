resource "shoreline_notebook" "etcd_high_fsync_durations_incident" {
  name       = "etcd_high_fsync_durations_incident"
  data       = file("${path.module}/data/etcd_high_fsync_durations_incident.json")
  depends_on = [shoreline_action.invoke_etcd_ping_traceroute,shoreline_action.invoke_etcd_fsync_check,shoreline_action.invoke_etcd_config_update]
}

resource "shoreline_file" "etcd_ping_traceroute" {
  name             = "etcd_ping_traceroute"
  input_file       = "${path.module}/data/etcd_ping_traceroute.sh"
  md5              = filemd5("${path.module}/data/etcd_ping_traceroute.sh")
  description      = "Check network connectivity and latency to Etcd server"
  destination_path = "/agent/scripts/etcd_ping_traceroute.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "etcd_fsync_check" {
  name             = "etcd_fsync_check"
  input_file       = "${path.module}/data/etcd_fsync_check.sh"
  md5              = filemd5("${path.module}/data/etcd_fsync_check.sh")
  description      = "High load: If the Etcd service is experiencing high traffic or a sudden spike in requests, it can cause the fsync duration to increase, leading to this incident."
  destination_path = "/agent/scripts/etcd_fsync_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "etcd_config_update" {
  name             = "etcd_config_update"
  input_file       = "${path.module}/data/etcd_config_update.sh"
  md5              = filemd5("${path.module}/data/etcd_config_update.sh")
  description      = "Optimize the Etcd configuration settings, such as the WAL sync interval and the number of concurrent compacting processes, to improve the system performance and reduce the fsync duration."
  destination_path = "/agent/scripts/etcd_config_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_etcd_ping_traceroute" {
  name        = "invoke_etcd_ping_traceroute"
  description = "Check network connectivity and latency to Etcd server"
  command     = "`chmod +x /agent/scripts/etcd_ping_traceroute.sh && /agent/scripts/etcd_ping_traceroute.sh`"
  params      = ["ETCD_SERVER_IP"]
  file_deps   = ["etcd_ping_traceroute"]
  enabled     = true
  depends_on  = [shoreline_file.etcd_ping_traceroute]
}

resource "shoreline_action" "invoke_etcd_fsync_check" {
  name        = "invoke_etcd_fsync_check"
  description = "High load: If the Etcd service is experiencing high traffic or a sudden spike in requests, it can cause the fsync duration to increase, leading to this incident."
  command     = "`chmod +x /agent/scripts/etcd_fsync_check.sh && /agent/scripts/etcd_fsync_check.sh`"
  params      = []
  file_deps   = ["etcd_fsync_check"]
  enabled     = true
  depends_on  = [shoreline_file.etcd_fsync_check]
}

resource "shoreline_action" "invoke_etcd_config_update" {
  name        = "invoke_etcd_config_update"
  description = "Optimize the Etcd configuration settings, such as the WAL sync interval and the number of concurrent compacting processes, to improve the system performance and reduce the fsync duration."
  command     = "`chmod +x /agent/scripts/etcd_config_update.sh && /agent/scripts/etcd_config_update.sh`"
  params      = ["CONCURRENT_COMPACTING_PROCESSES","PATH_TO_ETCD_CONFIG_FILE","WAL_SYNC_INTERVAL"]
  file_deps   = ["etcd_config_update"]
  enabled     = true
  depends_on  = [shoreline_file.etcd_config_update]
}

