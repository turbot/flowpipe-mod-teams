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
    description = "The name of the team."
  }

  param "team_description" {
    type        = string
    optional    = true
    description = "An optional description for the team."
  }

  param "visibility" {
    type        = string
    default     = "public"
    description = "The visibility of the group and team. Defaults to public"
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

  output "team_id" {
    value       = try(element(split("'", step.http.create_team.response_headers.Content-Location), 1), "")
    description = "The unique identifier of the team."
  }
}
