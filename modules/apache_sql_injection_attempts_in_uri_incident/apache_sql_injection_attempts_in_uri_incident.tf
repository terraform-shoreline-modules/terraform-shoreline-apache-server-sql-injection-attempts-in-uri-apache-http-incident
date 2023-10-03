resource "shoreline_notebook" "apache_sql_injection_attempts_in_uri_incident" {
  name       = "apache_sql_injection_attempts_in_uri_incident"
  data       = file("${path.module}/data/apache_sql_injection_attempts_in_uri_incident.json")
  depends_on = [shoreline_action.invoke_update_apache,shoreline_action.invoke_defend_sql_injection]
}

resource "shoreline_file" "update_apache" {
  name             = "update_apache"
  input_file       = "${path.module}/data/update_apache.sh"
  md5              = filemd5("${path.module}/data/update_apache.sh")
  description      = "Update and patch the Apache server to the latest stable version to prevent the exploitation of known vulnerabilities."
  destination_path = "/agent/scripts/update_apache.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "defend_sql_injection" {
  name             = "defend_sql_injection"
  input_file       = "${path.module}/data/defend_sql_injection.sh"
  md5              = filemd5("${path.module}/data/defend_sql_injection.sh")
  description      = "Create or Modify ModSecurity Rule to prevent SQL injection attacks."
  destination_path = "/agent/scripts/defend_sql_injection.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_apache" {
  name        = "invoke_update_apache"
  description = "Update and patch the Apache server to the latest stable version to prevent the exploitation of known vulnerabilities."
  command     = "`chmod +x /agent/scripts/update_apache.sh && /agent/scripts/update_apache.sh`"
  params      = []
  file_deps   = ["update_apache"]
  enabled     = true
  depends_on  = [shoreline_file.update_apache]
}

resource "shoreline_action" "invoke_defend_sql_injection" {
  name        = "invoke_defend_sql_injection"
  description = "Create or Modify ModSecurity Rule to prevent SQL injection attacks."
  command     = "`chmod +x /agent/scripts/defend_sql_injection.sh && /agent/scripts/defend_sql_injection.sh`"
  params      = ["REGEX_PATTERN_TO_MATCH_SQL_INJECTION","MODSECURITY_RULE_ID","MODSECURITY_RULESET_FILE"]
  file_deps   = ["defend_sql_injection"]
  enabled     = true
  depends_on  = [shoreline_file.defend_sql_injection]
}

