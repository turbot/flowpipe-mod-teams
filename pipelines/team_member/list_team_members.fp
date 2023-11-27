pipeline "list_team_members" {
  title       = "List Team Members"
  description = "Get the members of the specific Microsoft Team."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_id" {
    type        = string
    description = "The unique identifier for the team."
  }

  step "http" "list_team_members" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/members"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "members" {
    value       = step.http.list_team_members.response_body
    description = "Team members detail."
  }
}
