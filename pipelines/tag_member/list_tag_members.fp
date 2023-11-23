pipeline "list_tag_members" {
  title       = "List Teamwork Tag Members"
  description = "Get a list of the members of a standard tag in a team and their properties."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "teamwork_tag_id" {
    type        = string
    description = local.teamwork_tag_id_param_description
  }

  step "http" "list_tag_members" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "tag_members" {
    value       = jsondecode(step.http.list_tag_members.response_body).value
    description = "A collection of teamwork tag member object."
  }
}
