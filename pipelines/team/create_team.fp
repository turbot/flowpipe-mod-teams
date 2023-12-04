pipeline "create_team" {
  title       = "Create Team"
  description = "Create a new team."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
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
      Authorization = "Bearer ${param.access_token}"
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
