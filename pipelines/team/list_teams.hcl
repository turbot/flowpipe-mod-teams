// usage: flowpipe pipeline run list_teams
pipeline "list_teams" {
  title       = "List Joined Teams"
  description = "Get the teams in Microsoft Teams that the user is a direct member of."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  step "http" "list_teams" {
    title  = "List Joined Teams"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me/joinedTeams"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "teams" {
    value       = jsondecode(step.http.list_teams.response_body).value
    description = "The collection of team objects."
  }
}
