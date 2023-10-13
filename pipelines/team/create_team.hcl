// usage: flowpipe pipeline run create_team --pipeline-arg team_name="TEAM_NAME"
pipeline "create_team" {
  title       = "Create a New Team"
  description = "Create a new team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
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
    default     = "public" // or "private"
    description = "The visibility of the group and team. Defaults to public"
  }

  step "http" "create_team" {
    title  = "Create a New Team"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      displayName         = param.team_name,
      description         = param.team_description,
      isFavoriteByDefault = false,
      visibility          = param.visibility,
    })
  }

  output "team" {
    value       = step.http.create_team.response_body
    description = "The object for the team."
  }
}
