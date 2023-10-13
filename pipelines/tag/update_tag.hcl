// usage: flowpipe pipeline run update_tag  --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TEAMWORK_TAG_ID" --pipeline-arg new_tag_name="NEW_TAG_NAME"
pipeline "update_tag" {
  title       = "Update a Teamwork Tag"
  description = "Update the properties of a tag object."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
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
