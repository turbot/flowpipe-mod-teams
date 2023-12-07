pipeline "create_teamwork_tag" {
  title       = "Create Teamwork Tag"
  description = "Create a standard tag for members in a team."

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

  param "tag_name" {
    type        = string
    description = "The name of the tag as it appears to the user in Microsoft Teams."
  }

  param "user_id" {
    type        = string
    description = "The unique identifier for the user to add to the tag."
  }

  step "http" "create_teamwork_tag" {
    method = "post"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }

    request_body = jsonencode({
      displayName = param.tag_name,
      members = [{
        userId = param.user_id,
      }],
    })
  }

  output "teamwork_tag" {
    description = "The teamwork tag object."
    value       = step.http.create_teamwork_tag.response_body
  }
}
