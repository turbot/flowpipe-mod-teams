pipeline "list_teams" {
  title       = "List Joined Teams"
  description = "Get the teams in Microsoft Teams that the user is a direct member of."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  step "http" "list_teams" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/me/joinedTeams"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "teams" {
    description = "List of teams."
    value       = step.http.list_teams.response_body.value
  }
}
