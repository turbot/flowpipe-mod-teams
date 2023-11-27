pipeline "list_tags" {
  title       = "List Teamwork Tags"
  description = "Get a list of the tag objects and their properties."

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

  step "http" "list_tags" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "tags" {
    value       = jsondecode(step.http.list_tags.response_body).value
    description = "A collection of teamwork tag objects."
  }
}
