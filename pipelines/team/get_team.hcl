// usage: flowpipe pipeline run get_team --pipeline-arg team_id="TEAM_ID"
pipeline "get_team" {
  description = "Fetch the properties of an existing team."

  param "token" {
    type        = string
    default     = var.token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team"
  }

  step "http" "get_team" {
    title  = "Fetches the properties of an existing team"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "id" {
    value       = jsondecode(step.http.get_team.response_body).id
    description = "The ID of the team"
  }
  output "display_name" {
    value       = jsondecode(step.http.get_team.response_body).displayName
    description = "The display name of the team"
  }
  output "response_body" {
    value = step.http.get_team.response_body
  }
  output "response_headers" {
    value = step.http.get_team.response_headers
  }
  output "status_code" {
    value = step.http.get_team.status_code
  }
}
