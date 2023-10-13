// usage: flowpipe pipeline run get_team --pipeline-arg team_id="TEAM_ID"
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
    description = "The unique identifier of the team."
  }

  step "http" "get_team" {
    title  = "Get Team"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "team" {
    value       = step.http.get_team.response_body
    description = "The team object."
  }
}
