pipeline "list_team_members" {
  title       = "List Team Members"
  description = "Get the conversation member collection of a team."

  tags = {
    type = "featured"
  }

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

  step "http" "list_team_members" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/members?$top=999"

    request_headers = {
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }

    loop {
      until = lookup(result.response_body, "@odata.nextLink", null) == null
      url   = lookup(result.response_body, "@odata.nextLink", "")
    }
  }

  output "members" {
    description = "List of team members."
    value       = flatten([for entry in step.http.list_team_members : entry.response_body.value])
  }
}
