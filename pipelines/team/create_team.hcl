// usage: flowpipe pipeline run create_team --pipeline-arg team_name="TEAM_NAME"
pipeline "create_team" {
  title       = "Create a New Team"
  description = "Create a new team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access_token to use for the request."
  }

  param "team_name" {
    type        = string
    description = "The name of the team to create."
  }

  param "team_description" {
    type        = string
    default     = ""
    description = "The description of the team to create."
  }

  param "privacy_setting" {
    type        = string
    default     = "private" // or "public"
    description = "The privacy setting of the team to create."
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
      visibility          = param.privacy_setting,
    })
  }

  output "team" {
    value       = step.http.create_team.response_body
    description = "The newly created team."
  }
}
