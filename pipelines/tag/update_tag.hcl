// usage: flowpipe pipeline run update_tag  --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TEAMWORK_TAG_ID" --pipeline-arg new_tag_name="NEW_TAG_NAME"
pipeline "update_tag" {
  description = "Update a tag in a team."

  param "token" {
    type        = string
    default     = var.token
    description = "The access token to use for the request."
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
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      displayName = param.new_tag_name,
    })
  }

  output "id" {
    value       = jsondecode(step.http.update_tag.response_body).id
    description = "The ID of the tag"
  }
  output "display_name" {
    value       = jsondecode(step.http.update_tag.response_body).displayName
    description = "The display name of the tag"
  }
  output "member_count" {
    value       = jsondecode(step.http.update_tag.response_body).memberCount
    description = "The number of members in the tag"
  }
  output "response_body" {
    value = step.http.update_tag.response_body
  }
  output "response_headers" {
    value = step.http.update_tag.response_headers
  }
  output "status_code" {
    value = step.http.update_tag.status_code
  }
}
