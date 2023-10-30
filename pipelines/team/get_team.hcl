// usage: flowpipe pipeline run get_team --pipeline-arg team_id="9b68a1x9-ab01-5678-1234-956f2846aab4"
pipeline "get_team" {
  title       = "Get Team"
  description = "Retrieve the properties and relationships of the specified team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    default     = var.team_id
    description = "The unique identifier of the team."
  }

  step "http" "get_team" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "team" {
    value       = step.http.get_team.response_body
    description = "Team details."
  }

  output "status_code" {
    value = step.http.get_team.status_code
  }
}
