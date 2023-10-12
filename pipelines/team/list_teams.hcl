// usage: flowpipe pipeline run list_teams
pipeline "list_teams" {
  title       = "List Teams"
  description = "Retrieve a list of all teams."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access_token to use for the request."
  }

  step "http" "list_teams" {
    title  = "List Teams"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me/joinedTeams"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "teams" {
    value       = jsondecode(step.http.list_teams.response_body).value
    description = "The list of teams."
  }
}
