terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "etcd_high_fsync_durations_incident" {
  source    = "./modules/etcd_high_fsync_durations_incident"

  providers = {
    shoreline = shoreline
  }
}