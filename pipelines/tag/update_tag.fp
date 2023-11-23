pipeline "update_tag" {
  title       = "Update a Teamwork Tag"
  description = "Update the properties of a tag object."

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
    description = "The unique identifier for the tag."
  }

  param "new_tag_name" {
    type        = string
    description = "The name of the tag as it appears to the user in Microsoft Teams."
  }

  step "http" "update_tag" {
    title  = "Update a Teamwork Tag"
    method = "patch"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      displayName = param.new_tag_name,
    })
  }

  output "tag" {
    value       = step.http.update_tag.response_body
    description = "The teamwork tag object."
  }
}
