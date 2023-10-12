// usage: flowpipe pipeline run get_team --pipeline-arg team_id="TEAM_ID"
pipeline "get_team" {
  title       = "Get a team"
  description = "Fetch the properties of an existing team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access access_token to use for the request."
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
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "team" {
    value       = jsondecode(step.http.get_team.response_body)
    description = "The fetched team"
  }
}
