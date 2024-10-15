pipeline "list_teamwork_tag_members" {
  title       = "List Teamwork Tag Members"
  description = "Get a list of the members of a standard tag in a team and their properties."

  param "conn" {
    type        = connection.teams
    description = local.conn_param_description
    default     = connection.teams.default
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "teamwork_tag_id" {
    type        = string
    description = local.teamwork_tag_id_param_description
  }

  step "http" "list_teamwork_tag_members" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members?$top=999"

    request_headers = {
      Authorization = "Bearer ${param.conn.access_token}"
    }

    loop {
      until = lookup(result.response_body, "@odata.nextLink", null) == null
      url   = lookup(result.response_body, "@odata.nextLink", "")
    }
  }

  output "teamwork_tag_members" {
    description = "List of teamwork tag member object."
    value       = flatten([for entry in step.http.list_teamwork_tag_members : entry.response_body.value])
  }
}
