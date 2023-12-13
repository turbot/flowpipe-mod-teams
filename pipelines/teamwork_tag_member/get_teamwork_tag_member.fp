pipeline "get_teamwork_tag_member" {
  title       = "Get Teamwork Tag Member"
  description = "Get the properties and relationships of a member of a standard tag in a team."

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
  param "teamwork_tag_member_id" {
    type        = string
    description = "The unique identifier for the member."
  }

  step "http" "get_teamwork_tag_member" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members/${param.teamwork_tag_member_id}"

    request_headers = {
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }
  }

  output "teamwork_tag_member" {
    description = "A teamwork tag member object."
    value       = step.http.get_teamwork_tag_member.response_body
  }
}
