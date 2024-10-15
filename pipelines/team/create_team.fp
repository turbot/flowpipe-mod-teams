pipeline "create_team" {
  title       = "Create Team"
  description = "Create a new team."

  tags = {
    type = "featured"
  }

  param "conn" {
    type        = connection.microsoft_teams
    description = local.conn_param_description
    default     = connection.microsoft_teams.default
  }

  param "team_name" {
    type        = string
    description = local.team_name_param_description
  }

  param "team_description" {
    type        = string
    description = "An optional description for the team."
    optional    = true
  }

  param "visibility" {
    type        = string
    description = "The visibility of the group and team. Defaults to public."
    default     = "public"
  }

  step "http" "create_team" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }

    request_body = jsonencode({
      "template@odata.bind" = "https://graph.microsoft.com/v1.0/teamsTemplates('standard')"
      displayName           = param.team_name
      description           = param.team_description
      isFavoriteByDefault   = false
      visibility            = param.visibility
    })
  }

  output "team" {
    description = "The new team object."
    value       = step.http.create_team.response_body
  }
}
