pipeline "get_teamwork_tag" {
  title       = "Get Teamwork Tag"
  description = "Read the properties and relationships of a tag object."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "teamwork_tag_id" {
    type        = string
    description = local.teamwork_tag_id_param_description
  }

  step "http" "get_teamwork_tag" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }
  }

  output "teamwork_tag" {
    description = "The teamwork tag object."
    value       = step.http.get_teamwork_tag.response_body
  }
}
