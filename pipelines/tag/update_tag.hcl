// usage: flowpipe pipeline run update_tag  --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TEAMWORK_TAG_ID" --pipeline-arg new_tag_name="NEW_TAG_NAME"
pipeline "update_tag" {
  title       = "Update a tag"
  description = "Update a tag in a team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access access_token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team"
  }

  param "teamwork_tag_id" {
    type        = string
    description = "The ID of the teamwork tag"
  }

  param "new_tag_name" {
    type        = string
    description = "The new name of the tag"
  }

  step "http" "update_tag" {
    title  = "Updates an existing tag in a team"
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
    value       = jsondecode(step.http.update_tag.response_body)
    description = "The updated tag."
  }
}
