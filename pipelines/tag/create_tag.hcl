// usage: flowpipe pipeline run create_tag --pipeline-arg team_id="TEAM_ID" --pipeline-arg tag_name="TAG_NAME" --pipeline-arg user_id="USER_ID"
pipeline "create_tag" {
  title       = "Create a tag"
  description = "Create a new tag in a team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access access_token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team"
  }

  param "tag_name" {
    type        = string
    description = "The name of the tag"
  }

  param "user_id" {
    type        = string
    description = "The ID of the user to add to the tag"
  }

  step "http" "create_tag" {
    title  = "Create a new tag in a team"
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
    value       = jsondecode(step.http.create_tag.response_body)
    description = "The created tag."
  }
}
