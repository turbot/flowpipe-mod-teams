// usage: flowpipe pipeline run create_tag --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TEAMWORK_TAG_ID"
pipeline "delete_tag" {
  description = "Delete a tag in a team."

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

  step "http" "delete_tag" {
    title  = "Deletes an existing tag in a team"
    method = "delete"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "response_body" {
    value = step.http.delete_tag.response_body
  }
  output "response_headers" {
    value = step.http.delete_tag.response_headers
  }
  output "status_code" {
    value = step.http.delete_tag.status_code
  }
}
