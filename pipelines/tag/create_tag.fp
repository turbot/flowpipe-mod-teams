pipeline "create_tag" {
  title       = "Create a Teamwork Tag"
  description = "Create a standard tag for members in a team."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "tag_name" {
    type        = string
    description = "The name of the tag as it appears to the user in Microsoft Teams."
  }

  param "user_id" {
    type        = string
    description = "The unique identifier for the user to add to the tag."
  }

  step "http" "create_tag" {
    title  = "Create a Teamwork Tag"
    method = "post"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      displayName = param.tag_name,
      members = [{
        userId = param.user_id,
      }],
    })
  }

  output "tag" {
    value       = step.http.create_tag.response_body
    description = "The created teamwork tag object."
  }
}
