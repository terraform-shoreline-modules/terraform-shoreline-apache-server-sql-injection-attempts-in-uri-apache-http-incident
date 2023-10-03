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

module "apache_sql_injection_attempts_in_uri_incident" {
  source    = "./modules/apache_sql_injection_attempts_in_uri_incident"

  providers = {
    shoreline = shoreline
  }
}