pipeline "get_team" {
  title       = "Get Team"
  description = "Retrieve the properties and relationships of the specified team."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  step "http" "get_team" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}"

    request_headers = {
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }
  }

  output "team" {
    description = "A team object."
    value       = step.http.get_team.response_body
  }
}
