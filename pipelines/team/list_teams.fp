pipeline "list_teams" {
  title       = "List Teams"
  description = "Get the teams in Microsoft Teams that the user is a direct member of."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  step "http" "list_teams" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me/joinedTeams"

    request_headers = {
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }
  }

  output "teams" {
    description = "List of teams."
    value       = step.http.list_teams.response_body.value
  }
}
