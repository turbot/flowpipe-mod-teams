pipeline "create_teamwork_tag_member" {
  title       = "Create Teamwork Tag Member"
  description = "Create a new teamwork tag member object in a team."

  tags = {
    type = "featured"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

  param "user_id" {
    type        = string
    description = "The unique identifier for the user to add to the tag."
  }

  step "http" "create_teamwork_tag_member" {
    method = "post"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }

    request_body = jsonencode({
      userId = param.user_id,
    })
  }

  output "teamwork_tag_member" {
    description = "A teamwork tag member object."
    value       = step.http.create_teamwork_tag_member.response_body.value
  }
}
