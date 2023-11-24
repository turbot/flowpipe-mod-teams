pipeline "get_tag" {
  title       = "Get Teamwork Tag"
  description = "Read the properties and relationships of a tag object."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
    default     = var.team_id
  }

  param "teamwork_tag_id" {
    type        = string
    description = local.teamwork_tag_id_param_description
  }

  step "http" "get_tag" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "tag" {
    value       = step.http.get_tag.response_body
    description = "The teamwork tag object."
  }
}
