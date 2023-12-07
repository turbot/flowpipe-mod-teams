pipeline "list_teamwork_tags" {
  title       = "List Teamwork Tags"
  description = "Get a list of tag objects and their properties."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
    default     = var.team_id
  }

  step "http" "list_teamwork_tags" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags?$top=999"

    request_headers = {
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }

    loop {
      until = lookup(result.response_body, "@odata.nextLink", null) == null
      url   = lookup(result.response_body, "@odata.nextLink", "")
    }
  }

  output "teamwork_tags" {
    description = "A list of teamwork tag objects."
    value       = flatten([for entry in step.http.list_teamwork_tags : entry.response_body.value])
  }
}
