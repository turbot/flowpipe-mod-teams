// usage: flowpipe pipeline run create_tag --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TEAMWORK_TAG_ID"
pipeline "delete_tag" {
  title       = "Delete a Teamwork Tag"
  description = "Delete a tag object permanently."

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

  step "http" "delete_tag" {
    title  = "Delete a Teamwork Tag"
    method = "delete"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
