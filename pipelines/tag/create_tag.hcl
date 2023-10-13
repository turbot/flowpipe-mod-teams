// usage: flowpipe pipeline run create_tag --pipeline-arg team_id="TEAM_ID" --pipeline-arg tag_name="TAG_NAME" --pipeline-arg user_id="USER_ID"
pipeline "create_tag" {
  title       = "Create a Teamwork Tag"
  description = "Create a standard tag for members in a team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
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
