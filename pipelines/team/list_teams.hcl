// usage: flowpipe pipeline run list_teams
pipeline "list_teams" {
  description = "Retrieve a list of all teams."

  param "token" {
    type        = string
    default     = var.token
    description = "The access token to use for the request."
  }

  step "http" "list_teams" {
    title  = "Retrieve a list of teams"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me/joinedTeams"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "teams" {
    value       = jsondecode(step.http.list_teams.response_body).value
    description = "The list of teams."
  }
  output "response_headers" {
    value = step.http.list_teams.response_headers
  }
  output "status_code" {
    value = step.http.list_teams.status_code
  }
}
