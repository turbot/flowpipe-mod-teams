// usage: flowpipe pipeline run create_team --pipeline-arg team_name="TEAM_NAME"
pipeline "create_team" {
  description = "Create a new team."

  param "token" {
    type        = string
    default     = var.token
    description = "The access token to use for the request."
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
    title  = "Create a new team"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      displayName         = param.team_name,
      description         = param.team_description,
      isFavoriteByDefault = false,
      visibility          = param.privacy_setting,
    })
  }

  output "id" {
    value       = jsondecode(step.http.list_teams.response_body).value.id
    description = "The ID of the newly created team."
  }
  output "response_body" {
    value = step.http.create_team.response_body
  }
  output "response_headers" {
    value = step.http.create_team.response_headers
  }
  output "status_code" {
    value = step.http.create_team.status_code
  }
}
